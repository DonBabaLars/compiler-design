(* ll ir compilation -------------------------------------------------------- *)
open Ll
open Llutil
open X86


(* allocated llvmlite function bodies --------------------------------------- *)

module Alloc = struct

(* X86 locations *)
type loc =
  | LVoid               (* no storage *)
  | LReg of X86.reg     (* x86 register *)
  | LStk of int         (* a stack slot offset from %rbp (not a byte offset!)*)
  | LLbl of X86.lbl     (* an assembler label *)

type operand = 
  | Null
  | Const of int64
  | Gid of X86.lbl
  | Loc of loc

type insn =
  | ILbl of loc
  | PMov of (loc * ty * operand) list
  | Binop of loc * bop * ty * operand * operand
  | Alloca of loc * ty
  | Load of loc * ty * operand
  | Store of ty * operand * operand
  | Icmp of loc * Ll.cnd * ty * operand * operand
  | Call of loc * ty * operand * (ty * operand) list
  | Bitcast of loc * ty * operand * ty
  | Gep of loc * ty * operand * operand list
  | Ret of ty * operand option
  | Br of loc
  | Cbr of operand * loc * loc

let str_loc = function
  | LVoid  -> "LVoid"
  | LReg r  -> X86.string_of_reg r
  | LStk n -> Printf.sprintf "LStk %d" n
  | LLbl l -> l

let str_operand = function
  | Null -> "null"
  | Const x -> "Const _"
  | Gid l -> l
  | Loc l -> str_loc l


module LocSet = Set.Make (struct type t = loc let compare = compare end)
module UidSet = Datastructures.UidS

type fbody = (insn * LocSet.t) list

let map_operand f g : Ll.operand -> operand = function
  | Null -> Null
  | Const i -> Const i
  | Gid x -> Gid (g x)
  | Id u -> Loc (f u)

let map_insn f g : uid * Ll.insn -> insn = 
  let mo = map_operand f g in function
  | x, Binop (b,t,o,o') -> Binop (f x, b,t,mo o,mo o')
  | x, Alloca t         -> Alloca (f x, t)
  | x, Load (t,o)       -> Load (f x, t, mo o)
  | _, Store (t,o,o')   -> Store (t, mo o, mo o')
  | x, Icmp (c,t,o,o')  -> Icmp (f x, c, t, mo o, mo o')
  | x, Call (t,o,args)  -> Call (f x, t, mo o, List.map (fun (t,o) -> t, mo o) args)
  | x, Bitcast (t,o,t') -> Bitcast (f x, t, mo o, t')
  | x, Gep (t,o,is)     -> Gep (f x, t, mo o, List.map mo is)

let map_terminator f g : uid * Ll.terminator -> insn = 
  let mo = map_operand f g in function
  | _, Ret (t,None)   -> Ret (t, None)
  | _, Ret (t,Some o) -> Ret (t, Some (mo o))
  | _, Br l           -> Br (f l)
  | _, Cbr (o,l,l')   -> Cbr (mo o,f l,f l')

let map_lset f (s:UidSet.t) : LocSet.t =
  UidSet.fold (fun x t -> LocSet.add (f x) t) s LocSet.empty

let of_block
    (f:Ll.uid -> loc)
    (g:Ll.gid -> X86.lbl)
    (live_in:uid -> UidSet.t)
    (b:Ll.block) : fbody =
  List.map (fun (u,i) ->
      (* Uncomment this to enable verbose debugging output... *)
      (* Platform.verb @@ Printf.sprintf 
         "  * of_block: %s live_in = %s\n" u (UidSet.to_string (live_in u)); *)
      map_insn f g (u,i), map_lset f @@ live_in u) b.insns
  @ let x,t = b.term in
    [map_terminator f g (x,t), map_lset f @@ live_in x]
                                
let of_lbl_block f g live_in (l,b:Ll.lbl * Ll.block) : fbody =
  (ILbl (f l), map_lset f @@ live_in l)::of_block f g live_in b

let of_cfg
    (f : Ll.uid -> loc)
    (g : Ll.gid -> X86.lbl)
    (live_in : uid -> UidSet.t)
    (e, bs : Ll.cfg) : fbody =
  List.(flatten @@ of_block f g live_in e :: map (of_lbl_block f g live_in) bs)

end

module LocSet = Alloc.LocSet
module UidSet = Alloc.UidSet

let str_locset (lo:LocSet.t) : string =
  String.concat " " (List.map Alloc.str_loc (LocSet.elements lo))


(* streams of x86 instructions ---------------------------------------------- *)

type x86elt = 
  | I of X86.ins
  | L of (X86.lbl * bool)

type x86stream = x86elt list 

let lift : X86.ins list -> x86stream =
  List.rev_map (fun i -> I i)

let ( >@ ) x y = y @ x
let ( >:: ) x y = y :: x

let prog_of_x86stream : x86stream -> X86.prog =
  let rec loop p iis = function
    | [] -> (match iis with [] -> p | _ -> failwith "stream has no initial label")
    | (I i)::s' -> loop p (i::iis) s'
    | (L (l,global))::s' -> loop ({ lbl=l; global; asm=Text iis }::p) [] s'
  in loop [] []


(* locals and layout -------------------------------------------------------- *)

(* The layout for this version of the backend is slightly more complex
   than we saw earlier.  It consists of 
     - uid_loc a function that maps LL uids to their target x86 locations
     - the number of bytes to be allocated on the stack due to spills
*)

type layout = 
  { uid_loc : uid -> Alloc.loc
  ; spill_bytes : int
  }

(* The liveness analysis will return a record, with fields live_in and live_out,
   which are functions from uid to the set of variables that are live in (or
   live out) at a given program point denoted by the uid *)
type liveness = Liveness.liveness

(* The set of all caller-save registers available for register allocation *)
let caller_save : LocSet.t =
  [ Rdi; Rsi; Rdx; Rcx; R09; R08; Rax; R10; R11 ]
  |> List.map (fun r -> Alloc.LReg r) |> LocSet.of_list

(* excludes Rbp, Rsp, and Rip, since they have special meanings 
   The current backend does not use callee-save registers except in
   the special case of through registers.  It uses R15 as a function
   pointer, but ensures that it is saved/restored.
*)
let callee_save : LocSet.t =
  [ Rbx; R12; R13; R14; R15 ]
  |> List.map (fun r -> Alloc.LReg r) |> LocSet.of_list

let arg_reg : int -> X86.reg option = function
  | 0 -> Some Rdi
  | 1 -> Some Rsi
  | 2 -> Some Rdx
  | 3 -> Some Rcx
  | 4 -> Some R08
  | 5 -> Some R09
  | n -> None

let arg_loc (n:int) : Alloc.loc = 
  match arg_reg n with
  | Some r -> Alloc.LReg r
  | None -> Alloc.LStk (n-4)

let alloc_fdecl (layout:layout) (liveness:liveness) (f:Ll.fdecl) : Alloc.fbody =
  let dst  = List.map layout.uid_loc f.f_param in
  let tdst = List.combine (fst f.f_ty) dst in
  let movs = List.mapi (fun i (t,x) -> x, t, Alloc.Loc (arg_loc i)) tdst in
    (Alloc.PMov movs, LocSet.of_list dst)
  :: Alloc.of_cfg layout.uid_loc Platform.mangle liveness.live_in f.f_cfg

(* compiling operands  ------------------------------------------------------ *)

let compile_operand : Alloc.operand -> X86.operand = 
  let open Alloc in function
  | Null -> Asm.(~$0)
  | Const i -> Asm.(Imm (Lit i))
  | Gid l -> Asm.(~$$l)
  | Loc LVoid -> failwith "compiling uid without location"
  | Loc (LStk i) -> Asm.(Ind3 (Lit (Int64.of_int @@ i * 8), Rbp))
  | Loc (LReg r) -> Asm.(~%r)
  | Loc (LLbl l) -> Asm.(Ind1 (Lbl l))

let emit_mov (src:X86.operand) (dst:X86.operand) : x86stream = 
  let open X86 in match src, dst with
  | Imm (Lbl l), Reg _ -> lift Asm.[ Leaq, [Ind3 (Lbl l, Rip); dst ] ]
  | Imm (Lbl l), _     -> lift Asm.[ Leaq, [Ind3 (Lbl l, Rip); ~%Rax ]
                                   ; Movq, [~%Rax; dst ] ]
  | Reg r, Reg r' when r = r' -> []
  | Reg _, _ -> lift Asm.[ Movq, [src; dst] ]
  | _, Reg _ -> lift Asm.[ Movq, [src; dst] ]
  | _, _     -> lift Asm.[ Pushq, [src]; Popq,  [dst] ]


(* compiling parallel moves ------------------------------------------------- *)

(* Compiles a parallel move instruction into a sequence of moves, pushing and
   popping values to the stack when there are not enough registers to directly
   shuffle the sources to the targets. It uses liveness information to simply 
   not move dead operands.

   The PMov instruction is used at the beginning of a function declaration to 
   move the incoming arguments to their destination uids/registers.  
   compile_pmov is directly used when compiling a function call to move 
   the arguments.

   Inputs:
      live - the liveness information
      ol   - a list of triples of the form (dest, type, src)

   Note: the destinations are assumed to be distinct, but might also be sources

   Outputs:
      an x86 instruction stream that (efficiently) moves each src to its 
      destination

   The algorithm works like this:
      1. Filter out the triples in which srcs are dead or already in the right
          place. (none of those need to be moved)

   Then do a recursive algorithm that processes the remaining list of triples:
      2. See if there are triples of the form (dest, type, src) where dest
         is not also source in some other triple.  For each such triple we can 
         directly move the src to its dest (which won't "clobber" some other 
         source).  These are the "ready" moves.

      3. If there are no "ready" moves to make (i.e. every destination is also
         a source of some other triple), we pick the first triple, push its 
         src to the stack, recursively process the remaining list, and then
         pop the stack into the destination.

        ol          ol'          2           2             3           2         
      x <- y      x <- y       w <- x     MOV x, w      MOV x, w     MOV x, w
      y <- y  ==>         ==>  ------ ==> -------- ==>  PUSH y   ==> PUSH y
      w <- x      w <- x       x <- y     x <- y        y <- z       MOV z, y
      y <- z      y <- z       y <- z     y <- z        POP x        POP x

*)

let compile_pmov live (ol:(Alloc.loc * Ll.ty * Alloc.operand) list) : x86stream =
  let open Alloc in
  let module OpSet = Set.Make (struct type t = operand let compare = compare end) in

  (* Filter the moves to keep the needed ones:
     The operands that actually need to be moved are those that are
         - not in the right location already, and
         - still live                                                         *)
  let ol' = List.filter (fun (x, _, o) -> Loc x <> o && LocSet.mem x live) ol in

  let rec loop outstream ol =
    (* Find the _set_ of all sources that still need to be moved. *)
    let srcs = List.fold_left (fun s (_, _, o) -> OpSet.add o s) OpSet.empty ol in
    match List.partition (fun (x, _, o) -> OpSet.mem (Loc x) srcs) ol with
    | [], [] -> outstream

    (* when no moves are ready to be emitted, push onto stack *)
    | (x,_,o)::ol', [] -> 
       let os = loop (outstream >:: I Asm.( Pushq, [compile_operand o]))
                     ol' in
       os >:: I Asm.( Popq, [compile_operand (Loc x)] )

    (* when some destination of a move is not also a source *)
    | ol', ready ->
      loop (List.fold_left (fun os (x,_,o) ->
          os >@
          emit_mov (compile_operand o) (compile_operand (Loc x))) outstream ready)
        ol'
  in
  loop [] ol'


(* compiling call  ---------------------------------------------------------- *)

let compile_call live (fo:Alloc.operand) (os:(ty * Alloc.operand) list) : x86stream = 
  let oreg, ostk, _ = 
    List.fold_left (fun (oreg, ostk, i) (t, o) ->
        match arg_reg i with
        | Some r -> (Alloc.LReg r, t, o)::oreg, ostk, i+1
        | None -> oreg, o::ostk, i+1
      ) ([], [], 0) os in
  let nstack = List.length ostk in
  let live' = LocSet.of_list @@ List.map (fun (r,_,_) -> r) oreg in
  lift (List.map (fun o -> Pushq, [compile_operand o]) ostk)
  >@ compile_pmov (LocSet.union live live') oreg
  >:: I Asm.( Callq, [compile_operand fo] )
  >@ lift (if nstack <= 0 then []
           else Asm.[ Addq, [~$(nstack * 8); ~%Rsp] ])


(* compiling getelementptr (gep)  ------------------------------------------- *)

let rec size_ty tdecls t : int =
  begin match t with
    | Void | I8 | Fun _ -> 0
    | I1 | I64 | Ptr _ -> 8 (* Target 64-bit only subset of X86 *)
    | Struct ts -> List.fold_left (fun acc t -> acc + (size_ty tdecls t)) 0 ts
    | Array (n, t) -> n * (size_ty tdecls t)
    | Namedt id -> size_ty tdecls (List.assoc id tdecls)
  end

(* Compute the size of the offset (in bytes) of the nth element of a region
   of memory whose types are given by the list. Also returns the nth type. *)
let index_into tdecls (ts:ty list) (n:int) : int * ty =
  let rec loop ts n acc =
    begin match (ts, n) with
      | (u::_, 0) -> (acc, u)
      | (u::us, n) -> loop us (n-1) (acc + (size_ty tdecls u))
      | _ -> failwith "index_into encountered bogus index"
    end
  in loop ts n 0

let imm_of_int (n:int) = Imm (Lit (Int64.of_int n))

let compile_getelementptr tdecls (t:Ll.ty) (o:Alloc.operand)
    (path: Alloc.operand list) : x86stream  =

  let rec loop ty path (code : x86stream) =
    match (ty, path) with
    | (_, []) -> code

    | (Struct ts, Alloc.Const n::rest) ->
       let (offset, u) = index_into tdecls ts (Int64.to_int n) in
       loop u rest @@ (
         code >:: I Asm.(Addq, [~$offset; ~%Rax])
       )
         
    | (Array(_, u), Alloc.Const n::rest) ->
       (* Statically calculate the offset *)
       let offset = (size_ty tdecls u) * (Int64.to_int n) in
       loop u rest @@ (
         code >:: I Asm.(Addq, [~$offset; ~%Rax])
       )
         
    | (Array(_, u), offset_op::rest) ->
      loop u rest @@ (
        code >@
        ([I Asm.(Movq, [~%Rax; ~%Rcx])] >@
         (emit_mov (compile_operand offset_op) (Reg Rax)) >@
         [I Asm.(Imulq, [imm_of_int @@ size_ty tdecls u; ~%Rax])] >@
         [I Asm.(Addq, [~%Rcx; ~%Rax])] 
        )
      )
        
    | (Namedt t, p) -> loop (List.assoc t tdecls) p code

    | _ -> failwith "compile_gep encountered unsupported getelementptr data" in

  match t with
  | Ptr t -> loop (Array(0, t)) path (emit_mov (compile_operand o) (Reg Rax))
  | _ -> failwith "compile_gep got incorrect parameters"

(* compiling instructions within function bodies ---------------------------- *)


let compile_fbody tdecls (af:Alloc.fbody) : x86stream =
  let rec loop (af:Alloc.fbody) (outstream:x86stream) : x86stream =
    let cb = function
      | Ll.Add ->  Addq | Ll.Sub ->  Subq | Ll.Mul ->  Imulq
      | Ll.Shl ->  Shlq | Ll.Lshr -> Shrq | Ll.Ashr -> Sarq 
      | Ll.And ->  Andq | Ll.Or ->   Orq  | Ll.Xor ->  Xorq in
    let cc = function
      | Ll.Eq  -> Set Eq | Ll.Ne  -> Set Neq | Ll.Slt -> Set Lt
      | Ll.Sle -> Set Le | Ll.Sgt -> Set Gt  | Ll.Sge -> Set Ge in
    let co = compile_operand in

    let open Alloc in
    match af with
    | [] -> outstream

    | (ILbl (LLbl l), _)::rest ->
       loop rest @@ 
         (outstream
          >:: L (l, false) )

    | (PMov ol, live)::rest ->
       loop rest @@
         ( outstream
           >@ compile_pmov live ol )

    | (Icmp (LVoid, _,_,_,_), _)::rest ->  loop rest outstream
    | (Binop (LVoid, _,_,_,_), _)::rest -> loop rest outstream
    | (Alloca (LVoid, _), _)::rest -> loop rest outstream
    | (Bitcast (LVoid, _,_,_), _)::rest -> loop rest outstream
    | (Load (LVoid, _,_), _)::rest -> loop rest outstream
    | (Gep (LVoid, _,_,_), _)::rest -> loop rest outstream

    | (Icmp (x, c,_,Loc (LReg o),o'), _)::rest -> 
       loop rest @@
         ( outstream
           >@ lift Asm.[ Cmpq,       [co o'; ~%o]
                       ; cc c,       [co (Loc x)]
                       ; Andq,       [~$1; co (Loc x)] ] )


    | (Icmp (x, c,_,o,o'), _)::rest -> 
       loop rest @@
         ( outstream
           >@ emit_mov (co o) (Reg Rax)
           >@ lift Asm.[ Cmpq,       [co o'; ~%Rax]
                       ; cc c,       [co (Loc x)]
                       ; Andq,       [~$1; co (Loc x)] ] )

    (* Shift instructions must use Rcx or Immediate as second arg *)
    | (Binop (x, bop,_,o,o'), _)::rest
      when (bop = Shl || bop = Lshr || bop = Ashr)
      ->
       loop rest @@
         ( outstream
           >@ emit_mov (co o) (Reg Rax)
           >@ emit_mov (co o') (Reg Rcx)             
           >@ lift Asm.[ cb bop,     [~%Rcx; ~%Rax]
                       ; Movq,       [~%Rax; co (Loc x)] ] )

    | (Binop (LReg r, bop,_,o,o'), _)::rest
      when Loc (LReg r) = o' &&
        (bop = Add || bop = Mul || bop = And || bop = Or || bop = Xor) ->
      loop rest @@
         ( outstream
           >:: I Asm.( cb bop,       [co o; ~%r] ) )


    | (Binop (LReg r, b,_,o,o'), _)::rest when Loc (LReg r) <> o' ->
       loop rest @@
         ( outstream
           >@ emit_mov (co o) (Reg r)
           >:: I Asm.( cb b,       [co o'; ~%r] ) )

    | (Binop (x, b,_,o,o'), _)::rest ->
       loop rest @@
         ( outstream
           >@ emit_mov (co o) (Reg Rax)
           >@ lift Asm.[ cb b,       [co o'; ~%Rax]
                       ; Movq,       [~%Rax; co (Loc x)] ] )

    | (Alloca (x, at), _)::rest ->
       loop rest @@
         ( outstream
           >@ lift Asm.[ Subq, [~$(size_ty tdecls at); ~%Rsp]
                       ; Movq, [~%Rsp; co (Loc x)] ] )


    | (Bitcast (x, _,o,_), _)::rest ->
       loop rest @@ 
         ( outstream
           >@ emit_mov (co o) (Reg Rax)
           >:: I Asm.( Movq, [~%Rax; co (Loc x)] ) )


    | (Load (LReg x, _, Loc (LReg src)), _)::rest ->
       loop rest @@
         ( outstream 
           >:: I Asm.( Movq, [Ind2 src; ~%x] ) )

    | (Load (x, _, src), _)::rest ->
       loop rest @@
         ( outstream 
           >@ emit_mov (co src) (Reg Rax)
           >@ lift Asm.[ Movq, [Ind2 Rax; ~%Rax]
                       ; Movq, [~%Rax; co (Loc x)] ] )
      
    | (Store (_,Loc (LReg src),Loc (LReg dst)), _)::rest ->
       loop rest @@ 
         ( outstream 
           >:: I Asm.( Movq, [~%src; Ind2 dst] ) )

    | (Store (_,src,dst), _)::rest ->
       loop rest @@ 
         ( outstream 
           >@ emit_mov (co src) (Reg Rax)
           >@ emit_mov (co dst) (Reg Rcx)
           >:: I Asm.( Movq, [~%Rax; Ind2 Rcx] ) )

    | (Gep (x, at,o,os), _)::rest -> 
       loop rest @@ 
         ( outstream
           >@ compile_getelementptr tdecls at o os
           >:: I Asm.( Movq, [~%Rax; co (Loc x)] ) )

    | (Call (x, t,fo,os), live)::rest ->
      (* Corner: fo is Loc (LReg r) and r is used in the calling conventions.
         Then we use R15 to hold the function pointer, saving and restoring it, 
         since it is a callee-save register.                                  *)
      let fptr_op, init_fp, restore_fp =
        begin match fo with
          | Loc (LReg (Rdi | Rsi | Rdx | Rcx | R08 | R09)) ->
            Loc (LReg R15),
            [I Asm.(Pushq, [~%R15])] >@ (emit_mov (co fo) (Reg R15)),
            [I Asm.(Popq, [~%R15])]
          | _ -> fo, [], []     
        end
      in
      let () = Platform.verb @@ Printf.sprintf "call: %s live = %s\n"
          (str_operand fo) (str_locset live)
      in
       let save = LocSet.(elements @@ inter (remove x live) caller_save) in
       loop rest @@ 
       ( outstream
         >@ init_fp
         >@ lift (List.rev_map (fun x -> Pushq, [co (Loc x)]) save)
         >@ compile_call live fptr_op os
         >@ lift (List.map (fun x -> Popq, [co (Loc x)]) save)
         >@ restore_fp
         >@ (if t = Ll.Void || x = LVoid then [] 
             else lift Asm.[ Movq, [~%Rax; co (Loc x)] ]) )

    | (Ret (_,None), _)::rest ->
       loop rest @@ 
         ( outstream
           >@ lift Asm.[ Movq, [~%Rbp; ~%Rsp]
                       ; Popq, [~%Rbp]
                       ; Retq, [] ] )

    | (Ret (_,Some o), _)::rest ->
       loop rest @@ 
         ( outstream
           >@ emit_mov (co o) (Reg Rax)
           >@ lift Asm.[ Movq, [~%Rbp; ~%Rsp]
                       ; Popq, [~%Rbp]
                       ; Retq, [] ] )

    | (Br (LLbl l), _)::rest ->
       loop rest @@ 
         ( outstream
           >:: I Asm.( Jmp, [~$$l] ) )

    | (Cbr (Const i,(LLbl l1),(LLbl l2)), _)::rest ->
       loop rest @@
         ( outstream
           >:: (if i <> 0L
                then I Asm.( Jmp, [~$$l1] )
                else I Asm.( Jmp, [~$$l2] ) ) )

    | (Cbr (o,(LLbl l1),(LLbl l2)), _)::rest ->
       loop rest @@ 
         ( outstream
           >@ lift Asm.[ Cmpq,  [~$0; co o]
                       ; J Neq, [~$$l1]
                       ; Jmp,   [~$$l2] ] )

    | _ -> failwith "codegen failed to find instruction"
  in
  loop af []


(* compile_fdecl ------------------------------------------------------------ *)

(* Processes a function declaration by processing each of the subcomponents
   in turn:
     - first fold over the function parameters
     - then fold over the entry block
     - then fold over the subsequent blocks in their listed order
       To fold over a block:
           - fold over the label
           - then the instructions (in block order)
           - then the terminator

  See the examples no_reg_layout and greedy_layout for how to use this function.
*)
let fold_fdecl (f_param : 'a -> uid * Ll.ty -> 'a)
               (f_lbl  : 'a -> lbl -> 'a)
               (f_insn : 'a -> uid * Ll.insn -> 'a)
               (f_term : 'a -> uid * Ll.terminator -> 'a)
               (init:'a) (f:Ll.fdecl) : 'a =
  let fold_params ps a =
    List.fold_left f_param a ps in
  let fold_block {insns; term} a =
    f_term (List.fold_left f_insn a insns) term in
  let fold_lbl_block (l,blk) a =
    fold_block blk (f_lbl a l) in
  let fold_lbl_blocks bs a =
    List.fold_left (fun a b -> fold_lbl_block b a) a bs in
  let entry,bs = f.f_cfg in
  (init 
  |> fold_params (List.combine f.f_param (fst f.f_ty))
  |> fold_block entry
  |> fold_lbl_blocks bs)
  

(* no layout ---------------------------------------------------------------- *)
(* This register allocation strategy puts all uids into stack
   slots. It does not use liveness information.  
*)
let insn_assigns : Ll.insn -> bool = function
  | Ll.Call (Ll.Void, _, _) | Ll.Store _ -> false
  | _ -> true

let no_reg_layout (f:Ll.fdecl) (_:liveness) : layout =
  let lo, n_stk = 
    fold_fdecl
      (fun (lo, n) (x, _) -> (x, Alloc.LStk (- (n + 1)))::lo, n + 1)
      (fun (lo, n) l -> (l, Alloc.LLbl (Platform.mangle l))::lo, n)
      (fun (lo, n) (x, i) ->
        if insn_assigns i 
        then (x, Alloc.LStk (- (n + 1)))::lo, n + 1
        else (x, Alloc.LVoid)::lo, n)
      (fun a _ -> a)
      ([], 0) f in
  { uid_loc = (fun x -> List.assoc x lo)
  ; spill_bytes = 8 * n_stk
  }

(* greedy layout ------------------------------------------------------------ *)
(* This example register allocation strategy puts the first few uids in 
   available registers and spills the rest. It uses liveness information to
   recycle available registers when their current value becomes dead.

   There is a corner case where we might have to try to allocate a location
   but there is a live variable who's location is unknown!  (This can happen
   in a loop... see gcd_euclidean.ll for an example.)  In that case, we 
   should just spill to avoid conflicts.
*)

let greedy_layout (f:Ll.fdecl) (live:liveness) : layout =
  let n_arg = ref 0 in
  let n_spill = ref 0 in

  let spill () = (incr n_spill; Alloc.LStk (- !n_spill)) in
  
  (* Allocates a destination location for an incoming function parameter.
     Corner case: argument 3, in Rcx occupies a register used for other
     purposes by the compiler.  We therefore always spill it.
  *)
  let alloc_arg () =
    let res =
      match arg_loc !n_arg with
      | Alloc.LReg Rcx -> spill ()
      | x -> x
    in
    incr n_arg; res
  in
  (* The available palette of registers.  Excludes Rax and Rcx *)
  let pal = LocSet.(caller_save 
                    |> remove (Alloc.LReg Rax)
                    |> remove (Alloc.LReg Rcx)                       
                   )
  in

  (*  Allocates a uid greedily based on liveness information      *)
  let allocate lo uid =
    let loc =
    try
      let used_locs = (* computes all the registers that are live at the point of entry *)
        UidSet.fold (fun y -> LocSet.add (List.assoc y lo)) (live.live_in uid) LocSet.empty
      in
      let available_locs = LocSet.diff pal used_locs in
      LocSet.choose available_locs
    with
    | Not_found -> spill ()
    in
    Platform.verb @@ Printf.sprintf "allocated: %s <- %s\n" (Alloc.str_loc loc) uid; loc
  in

  let final_lo =
    fold_fdecl
      (fun lo (x, _) -> (x, alloc_arg())::lo)
      (fun lo l -> (l, Alloc.LLbl (Platform.mangle l))::lo)
      (fun lo (x, i) ->
        if insn_assigns i 
        then (x, allocate lo x)::lo
        else (x, Alloc.LVoid)::lo)
      (fun lo _ -> lo)
      [] f in
  { uid_loc = (fun x -> List.assoc x final_lo)
  ; spill_bytes = 8 * !n_spill
  }


(*
   fold_fdecl :: (f_param : 'a -> uid * Ll.ty -> 'a)
                   (f_lbl  : 'a -> lbl -> 'a)
                   (f_insn : 'a -> uid * Ll.insn -> 'a)
                   (f_term : 'a -> uid * Ll.terminator -> 'a)
                   (init:'a) (f:Ll.fdecl) : 'a

  type liveness = {live_in : uid -> UidS.t; live_out : uid -> UidS.t}
*)

(* better register allocation ----------------------------------------------- *)
(* TASK: Implement a (correct) register allocation strategy that
   outperforms the greedy layout strategy given above, assuming that
   the liveness information is calculated using the dataflow analysis
   from liveness.ml.  

   Your implementation does _not_ necessarily have to do full-blown 
   coalescing graph coloring as described in lecture.  You may choose 
   a simpler strategy.  In particular, a non-coalescing graph coloring 
   algorithm that uses some simple preference heuristics should be 
   able to beat the greedy algorithm.

   To measure the effectiveness of your strategy, our testing infrastructure 
   uses a simple heuristic to compare it with the 'greedy' strategy given above.
   
   QUALITY HEURISTIC:
   The 'quality score' of a register assignment for an x86 program is based
   on two things: 
     - the total number of memory accesses, which is the sum of:
          - the number of Ind2 and Ind3 operands 
          - the number of Push and Pop instructions

     - size(p) the total number of instructions in the x86 program

   Your goal for register allocation should be to minimize the number of 
   memory operations and, secondarily, the overall size of the program.

   registers.ml provides some helper functions that you can use to 
   get the size and total number of memory operations in a program.  It 
   also provides a function that computes a histogram of the register usage,
   which can be helpful when testing your register allocator.

   To see whether your register assignment is better than the greedy one,
   we check:
      if #mem_ops(yours) < #mem_ops(greedy)  then yours is better
     otherwise if size(yours) < size(greedy) then yours is better
     otherwise greedy wins.

   Hints:
    - The Datastructures file provides a UidMap that can be used to 
      create your interference graph.

    - It may be useful to understand how this version of the compiler
      deals with function calls (see compile_pmov) and what the 
      greedy allocator does.

    - The compiler uses Rax and Rcx in its code generation, so they
      are _not_ generally available for your allocator to use.

      . other caller_save registers are freely available

      . if you want to use callee_save registers you might have to 
        adjust the code generated by compile_fdecl to save/restore them.
*)  

module UidMap = Datastructures.UidM


let printGraph (graph:UidSet.t UidMap.t) : unit =
  let str = UidMap.to_string (fun uid set -> (" -> "^(UidSet.to_string set)^"\n")) graph in
  print_endline "";
  print_endline "---------------------Printing Graph---------------------------------";
  print_endline str;
  print_endline "--------------------------------------------------------------------"

let printColoring (coloring: int UidMap.t) : unit =
  let str = UidMap.to_string (fun uid i -> (" -> "^(Int.to_string i)^"\n")) coloring in
  print_endline "";
  print_endline "---------------------Printing Coloring---------------------------------";
  print_endline str;
  print_endline "--------------------------------------------------------------------"


let print_uid_uidset (uid:Ll.uid) (uidset:UidSet.t) : unit = 
  print_endline ("adding uid: "^uid^" -> " ^(UidSet.to_string uidset))



let makeGraph (f:fdecl) (live:liveness) : UidSet.t UidMap.t   =
    let cfg = f.f_cfg in
    let (entry, lblblocks) = cfg in
    let blocks = entry :: (List.map snd lblblocks) in

    (* updates the mapping of a id with all the members of new_set*)
    let updateSet (new_set:UidSet.t) (id:Ll.uid) (graph:UidSet.t UidMap.t) : UidSet.t UidMap.t = 
        let map_set = UidMap.find id graph in           (*find set mapped from current id*)
        let new_set = UidSet.remove id new_set in       (*remove id from folding set*)
        UidMap.add id (UidSet.union map_set new_set) graph  
    in

    (* consumes an instruction and adds live_in adjacency to the closure *)
    let addEntry (graph:UidSet.t UidMap.t) (uid,insn :Ll.uid * Ll.insn) : UidSet.t UidMap.t =


      let live_in = live.live_in uid in
      (* let live_in = match insn with
        |Load (ty,op) -> UidSet.add uid live_in
        |_ -> live_in
      in *)


      (* print_uid_uidset uid live_in; *)
      (* folds updateId over live_in set  accumulating in graph*)
      UidSet.fold (updateSet live_in) live_in graph  
    in

    let rec addBlocks (bs:Ll.block list) (graph:UidSet.t UidMap.t) (live:liveness) : UidSet.t UidMap.t =
      match bs with 
        |[] -> graph
        |b::bs -> 
          let {insns;term} = b in
          (* let uids = List.map fst insns in *)
          let term_id = fst term in


          (* let graph = UidMap.update (fun x -> UidSet.union x (live.live_in term_id)) term_id  graph in *)
          let graph = UidSet.fold (updateSet (live.live_in term_id)) (live.live_in term_id) graph in
          let new_graph = List.fold_left (addEntry) graph insns in 

          (addBlocks bs new_graph live)
    in

    let has_liveness ((u,i) : Ll.uid * Ll.insn) : bool =
      match i with
        |Store (_,_,_) -> false
        |_-> true
    in

    let rec uidsFromBlocks (blocks:Ll.block list) (uids:uid list) : uid list =
      match blocks with 
        |[] -> uids
        |b::bs -> 
          let {insns;term} = b in
          let uids = (List.map fst (List.filter has_liveness insns)) @ uids in
          uidsFromBlocks bs uids
    in

    let uidsFromFdecl (fdecl:Ll.fdecl) : uid list = 
      let {f_ty;f_param;f_cfg} = fdecl in
      let (block, lblblocks) = f_cfg in  
      let blocks = block :: (List.map snd lblblocks) in
      uidsFromBlocks blocks f_param 
    in

    let uids = uidsFromFdecl f in 

    let init_graph = List.fold_left (fun g uid -> UidMap.add uid UidSet.empty g) UidMap.empty uids in
    (* printGraph init_graph; *)
    let param_set = UidSet.of_list f.f_param in 
    let fparam_graph = UidSet.fold (updateSet param_set) param_set init_graph in
    let graph = addBlocks blocks fparam_graph live in
    (* printGraph graph; *)
    graph


  
    (*Terminators and stores are in the Graph but dont need to, cause they never conflict*)

(* makes a map where a uid maps to Boolean saying if it is move related to rax *)
(* let analyze_move_related (f:fdecl) : Bool UidMap.t =  *)




let better_layout (f:Ll.fdecl) (live:liveness) : layout = 

  let debug = ref false in

  let n_arg = ref 0 in
  let n_spill = ref 0 in

  let nrRegs = ref 7 in

  let spill () = (incr n_spill; Alloc.LStk (- !n_spill)) in
  
  (* Allocates a destination location for an incoming function parameter.
     Corner case: argument 3, in Rcx occupies a register used for other
     purposes by the compiler.  We therefore always spill it.
  *)
  let alloc_arg () =
    let res =
      match arg_loc !n_arg with
      | Alloc.LReg Rcx -> 
        if !debug then print_endline "spilling in alloc_arg...";
        (* spill () *)
        Alloc.LReg R11
      | x -> x
    in
    incr n_arg; res
  in

  let graph = makeGraph f live in
  (* printGraph graph; *)

  (* simplifies g recursively and returns the remaining graph and the built stack*)
  (* More detail:
      We recursively call a fold on the map until the map "converged" = doesnt change anymore 
      The fold just removes any node with degree less than k=15
  *)
  let rec simplify g (stack:Ll.uid list) : (UidSet.t UidMap.t * (Ll.uid list)) =
  begin
    let (g', stack') = UidMap.fold
      (fun x y (g', stack') ->
        if UidSet.cardinal y < !nrRegs then
          let g' = UidMap.remove x g' in
          let g' = UidMap.map (UidSet.remove x) g' in
          (g', x::stack')
        else
          (g', stack')
      ) g (g, stack)
    in
    if stack' = stack then ((g', stack')) else (simplify g' stack')
  end
   in
          
  (* Spills a node from the graph *)
  let spill_node g spilled_stack : (UidSet.t UidMap.t * (Ll.uid list))= 
  begin
    (* choose the node with highest cardinality*)
    let (x, y) = UidMap.max_binding g in
    (* let (x, y) = UidMap.choose g in  *)
    let g' = UidMap.remove x g in
    let g'' = UidMap.map (UidSet.remove x) g' in
    let spilled_stack' = spilled_stack @ [x] in (* switch to get min degree spilled node first *)
    if !debug then print_endline ("Spilling node: "^x);
    (* spill (); *)
    (g'', spilled_stack')
  end
  in
  
  (* Takes a graph. It simplifies the graph (repeatedly) until the remaining graph
     is empty (meaning we are able to color the graph wit k colors).
     On every itaration on which it was not able to simplfy to an empty graph it spills a node.
     IMPORTANT: We will later need the "original" graph for coloring, BUT we do not actually
          want the original original graph as we spilled some nodes by the end of this function!
          So we will remove every spilled node from the original graph on each iteration and in
          the end return this "original" graph with all the spilled nodes removed. (As we want to ignore those for the coloring)
    It returns the "original" graph (with spilled nodes removed) and the stack (which was 
    returned by the last successful simplify call) which will be used for coloring
  *)
  let return_unspilled_graph_and_stack g : (UidSet.t UidMap.t * (uid list) * (uid list)) = (* Returns the Graph with all spilled nodes removed and the stack for coloring*)
  begin  
  let rec repeat_until_graph_empty g spilled_stack : (UidSet.t UidMap.t * (uid list) * (uid list)) = 
      let (g', stack') = simplify g [] in
      (* Check if the simplified graph is empty *)
      if UidMap.is_empty g'
        then (* if empty return the current(!!) Graph and the computed stack *)
          (g, stack', spilled_stack)
        else (* if not empty, spill and retry *)
      
          let (spilled_g,spilled_stack) = spill_node g spilled_stack in
          repeat_until_graph_empty spilled_g spilled_stack
    in
    repeat_until_graph_empty g []
  end
  in

  (* Gets a Uid set (which doenst actually contain uids, but colors 1...k)
     loops for 1...k until it finds a number that is not in the set
     if it doesnt find a number up to k=15 it fails
  *)
  let find_missing_number (set:UidSet.t) : int =
  begin
    let rec aux n =
      if n > !nrRegs then
        (if !debug then print_endline "Couldnt find a color for a node";
        -2)
      else if UidSet.mem (Int.to_string n) set then 
        aux (n + 1) 
      else 
        n
    in
    aux 1
  end
  in

  (* Gets a graph (the current partial graph), a coloring for that graph and a node x
     We abuse the UidSet to store the colors of the neighbours of x.
     We call find_missing_number on this set of Uid (which doesnt actually contain uids but colors 1 .. k)
     NOTE: We only take neighbours that have a color already (because we built up using the stack and only
          added nodes that have a color already)
     NOTE: We dont have to worry about trying to color spilled nodes as we removed them from the graph
          (and the stack) already
  *)
  let get_color (g:UidSet.t UidMap.t) (coloring:int UidMap.t) (uid:uid) : int = (* Returns the color of the node x *)
  begin
    (* make a set of colors that are taken by neighbours *)
    let taken_colors = 
      let neighbours = UidMap.find uid g in
      (* get the colors of the neighbours *)
      UidSet.fold (fun y ->
        let temp = match UidMap.find_opt y coloring with
          | Some color -> UidSet.add (Int.to_string color)
          | None -> UidSet.add "-1" (* This will not change the result as its only used to find a new color and not 
                                        actually assigned to y. Negative numbers are ignored when finding a new color*)
        in 
        temp
        ) neighbours UidSet.empty
    in
      
    (* find the first color that is not taken *)
    find_missing_number taken_colors
  end
  in


  (* Gets a graph (the original graph with spilled nodes removed) and a coloring for that graph
     And returns a coloring for that graph by
          - going through the stack
          - for each node x in the stack, get a color for x (choose color not taken by neighbours CURRENTLY** in the Graph)
          - add x to the coloring

    ** In get_color we only take neighbours with a color as only those were yet "added" to the graph and are relevant
  *)
  let color_graph g args stack : int UidMap.t = 
  begin
    let coloring = UidMap.empty in
    let rec color_args g stack coloring args : int UidMap.t =
      match args with
      | [] -> coloring
      | x::xs -> 
        (* check if x is on stack *)
        match List.mem x stack with
        | false -> 
          color_args g stack coloring xs
        | true ->
        let color = get_color g coloring x in
        let coloring' = UidMap.add x color coloring in
        (* remove node from stack if contained *)
        let stack = List.filter (fun y -> y <> x) stack in
        color_args g stack coloring' xs
    in
    let rec color_graph' g stack coloring : int UidMap.t = 
      match stack with
      | [] -> coloring
      | x::xs -> 
        let color = get_color g coloring x in
        let coloring' = UidMap.add x color coloring in
        color_graph' g xs coloring'
    in
    let coloring = color_args g stack coloring args in
    color_graph' g stack coloring
  end
  in

  let try_coloring_spilled_nodes (g:UidSet.t UidMap.t) (coloring:int UidMap.t) (spilled_stack:uid list): int UidMap.t =
    begin
      let rec aux g coloring spilled_stack : int UidMap.t =
        match spilled_stack with
        | [] -> coloring
        | x::xs -> 
          let color = get_color g coloring x in
          match color with
          | -2 -> aux g coloring xs
          | _ -> 
            if !debug then print_endline "was able to color a spilled node :)";
            let coloring' = UidMap.add x color coloring in
            aux g coloring' xs 
      in
      aux g coloring spilled_stack

    end
  in
  

  (* Processes the Graph and returns its coloring *)
  let get_coloring g args: int UidMap.t = 
  begin
    let (g', stack, spilled_stack) = return_unspilled_graph_and_stack g in
    let coloring = color_graph g' args stack in
    try_coloring_spilled_nodes g coloring spilled_stack
  end
  in


  (* [ Rdi; Rsi; Rdx; Rcx; R09; R08; Rax; R10; R11 ] *)

  (* Gets the location of a uid from the coloring *)
  let get_loc (coloring:int UidMap.t) (map:(int*Alloc.loc) list) (uid:uid) : Alloc.loc = 
    match UidMap.find_opt uid coloring with
    | Some color -> (try List.assoc color map with Not_found -> failwith "List.assoc failed :(")
    | None ->
      if !debug then print_endline "spilling in get_loc";
      spill()
  in

  let pal = LocSet.(caller_save 
                    |> remove (Alloc.LReg Rax)
                    |> remove (Alloc.LReg Rcx)                       
                   )
  in

  let rec complete_map (i:int) (pal:LocSet.t) (map:(int * Alloc.loc) list) : (int * Alloc.loc) list =
    begin match i with
      |8 -> map

      |_ ->
        begin match (List.filter (fun (col,loc) -> col = i) map) with
          |[] -> 
            let loc = try LocSet.choose pal with Not_found -> failwith "Loc.choose failed :(" in 
            let new_pal = LocSet.remove loc pal in 
            complete_map (i+1) new_pal ((i,loc)::map) 
          |_ -> complete_map (i+1) pal map
        end

    end
  in

  let rec map_fargs (arg_uids:Ll.uid list) (coloring:int UidMap.t) (pal:LocSet.t) (map:(int * Alloc.loc) list) : (int * Alloc.loc) list =  
    begin match arg_uids with
      |[] -> complete_map 1 pal map (*incomplete*)
      |uid::uids -> 
        let col = UidMap.find_opt uid coloring in (* color of function argument*)
        begin match col with
          |Some color ->
            let location = alloc_arg () in
            let new_pal = LocSet.remove location pal in 
            if !debug then print_endline ("mapping color: "^(Int.to_string color)^" to loc: "^(Alloc.str_loc location));
            map_fargs uids coloring new_pal ((color,location)::map)
          |None -> 
            spill();
            map_fargs uids coloring pal map
        end
    end

  
  in 
  
  (* printGraph graph; *)
  let coloring = get_coloring graph f.f_param in
  (* printColoring coloring;  *)
  (* printGraph graph; *)



  let map = map_fargs f.f_param coloring pal [] in (*   (int, Alloc.loc) list *)

  
  (* print_endline "------------------PRINTING LAYOUT----------------------------------";
  List.map (fun (i,loc) -> print_endline ((string_of_int i)^" -> "^(Alloc.str_loc loc))) map; *)

  


  let final_lo =
  begin
    fold_fdecl
      (fun lo (uid, _) -> (uid, get_loc coloring map uid )::lo)
      (fun lo l -> (l, Alloc.LLbl (Platform.mangle l))::lo)
      (fun lo (uid, ins) ->
        if insn_assigns ins 
        then (uid, get_loc coloring map uid)::lo
        else (uid, Alloc.LVoid)::lo)
      (fun lo _ -> lo)
      [] f 
  end
  in
  { uid_loc = (fun x -> List.assoc x final_lo)
  ; spill_bytes = 8 * !n_spill
  }
  
  (*
   let fold_fdecl (f_param : 'a -> uid * Ll.ty -> 'a)
               (f_lbl  : 'a -> lbl -> 'a)
               (f_insn : 'a -> uid * Ll.insn -> 'a)
               (f_term : 'a -> uid * Ll.terminator -> 'a)
               (init:'a) (f:Ll.fdecl) : 'a =
  let fold_params ps a =
    List.fold_left f_param a ps in
  let fold_block {insns; term} a =
    f_term (List.fold_left f_insn a insns) term in
  let fold_lbl_block (l,blk) a =
    fold_block blk (f_lbl a l) in
  let fold_lbl_blocks bs a =
    List.fold_left (fun a b -> fold_lbl_block b a) a bs in
  let entry,bs = f.f_cfg in
  (init 
  |> fold_params (List.combine f.f_param (fst f.f_ty))
  |> fold_block entry
  |> fold_lbl_blocks bs)
  *)



(* register allocation options ---------------------------------------------- *)
(* A trivial liveness analysis that conservatively says that every defined
   uid is live across every edge. *)
let trivial_liveness (f:Ll.fdecl) : liveness =
  let s = 
    fold_fdecl
      (fun s (x, _) -> UidSet.add x s)
      (fun s _ -> s)
      (fun s (x, i) -> if insn_assigns i then UidSet.add x s else s)
      (fun s _ -> s)
      UidSet.empty f in 
  {live_in = (fun _ -> s); live_out = (fun _ -> s)}

let liveness_fn : (Ll.fdecl -> liveness) ref =
  ref trivial_liveness

let layout_fn : (Ll.fdecl -> liveness -> layout) ref =
  ref no_reg_layout

(* Consistency check for layout, i.e., make sure that a layout does not use the
   same location for variables that are live at the same time *)
let check_layout (lay:layout) (live:liveness) (f:Ll.fdecl) =
  (* Check that uid is not allocated to the same location as any uid in s *)
  let check_disjoint uid s =
    let loc = lay.uid_loc uid in
    if loc <> LVoid then
      UidSet.iter
        (fun v -> if v <> uid && loc = (lay.uid_loc v) then
            failwith @@
            Printf.sprintf
              "Invalid layout %s and %s both map to %s"
              uid v (Alloc.str_loc loc))
        s
  in
  UidSet.iter
    (fun x ->
      let live_in = try (live.live_in x) with Not_found -> UidSet.empty in
      UidSet.iter (fun y -> check_disjoint y live_in) live_in)
    (fold_fdecl
       (fun s (x, _) -> UidSet.add x s)
       (fun s _ -> s)
       (fun s (x, i) -> if insn_assigns i then UidSet.add x s else s)
       (fun s _ -> s)
       UidSet.empty f)



let set_liveness name =
  liveness_fn := match name with
  | "trivial" -> trivial_liveness
  | "dataflow" -> Liveness.get_liveness
  | _ -> failwith "impossible arg"

let set_regalloc name = 
  layout_fn := match name with
  | "none"   -> no_reg_layout
  | "greedy" -> greedy_layout
  | "better" -> better_layout
  | _ -> failwith "impossible arg"

(* Compile a function declaration using the chosen liveness analysis
   and register allocation strategy. *)
let compile_fdecl tdecls (g:gid) (f:Ll.fdecl) : x86stream =
  let liveness = !liveness_fn f in
  let layout = !layout_fn f liveness in
  (* 
     Help out students by checking that the layout is correct with 
     respect to liveness.
  *)
  let _ = check_layout layout liveness f in 
  let afdecl = alloc_fdecl layout liveness f in
  [L (Platform.mangle g, true)]
  >@ lift Asm.[ Pushq, [~%Rbp]
              ; Movq,  [~%Rsp; ~%Rbp] ]
  >@ (if layout.spill_bytes <= 0 then [] else
      lift Asm.[ Subq,  [~$(layout.spill_bytes); ~%Rsp] ])
  >@ (compile_fbody tdecls afdecl)

(* compile_gdecl ------------------------------------------------------------ *)

let rec compile_ginit = function
  | GNull      -> [Quad (Lit 0L)]
  | GGid gid   -> [Quad (Lbl (Platform.mangle gid))]
  | GInt c     -> [Quad (Lit c)]
  | GString s  -> [Asciz s]
  | GArray gs 
  | GStruct gs -> List.(flatten @@ map compile_gdecl gs)
  | GBitcast (t1,g,t2) -> compile_ginit g

and compile_gdecl (_, g) = compile_ginit g

let optimize_prog (prog:X86.prog) : X86.prog =
  
  let filter_insn (i:X86.ins) : bool =
    match i with
      |Addq, [Imm (Lit 0L); _] -> false
      |_ -> true
  in

  let opt_asm (asm:X86.asm) : X86.asm =
    let Text insns = asm in
    (Text (List.filter filter_insn insns))
  in



  let opt_elem (e:X86.elem) : X86.elem =
    let {lbl;global;asm} = e in
    begin match asm with
      |Text insns -> {lbl;global;asm=opt_asm asm}
      |_ -> {lbl;global;asm}
    end
  in


  List.map opt_elem prog

(* compile_prog ------------------------------------------------------------- *)
let compile_prog {tdecls; gdecls; fdecls} : X86.prog =
  let g = fun (lbl, gdecl) ->
    Asm.data (Platform.mangle lbl) (compile_gdecl gdecl)
  in

  let f = fun (name, fdecl) ->
    prog_of_x86stream @@ compile_fdecl tdecls name fdecl
  in
  let compiled_gdecls = (List.map g gdecls) in
  let compiled_fdecls = List.(flatten @@ map f fdecls) in
  let prog = compiled_gdecls @ compiled_fdecls in
  (* let prog = optimize_prog prog in *)
  prog
