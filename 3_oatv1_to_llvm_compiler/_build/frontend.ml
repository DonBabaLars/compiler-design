open Ll
open Llutil
open Ast

(* instruction streams ------------------------------------------------------ *)

(* As in the last project, we'll be working with a flattened representation
   of LLVMlite programs to make emitting code easier. This version
   additionally makes it possible to emit elements will be gathered up and
   "hoisted" to specific parts of the constructed CFG
   - G of gid * Ll.gdecl: allows you to output global definitions in the middle
     of the instruction stream. You will find this useful for compiling string
     literals
   - E of uid * insn: allows you to emit an instruction that will be moved up
     to the entry block of the current function. This will be useful for 
     compiling local variable declarations
*)

type elt = 
  | L of Ll.lbl             (* block labels *)
  | I of uid * Ll.insn      (* instruction *)
  | T of Ll.terminator      (* block terminators *)
  | G of gid * Ll.gdecl     (* hoisted globals (usually strings) *)
  | E of uid * Ll.insn      (* hoisted entry block instructions *)

type stream = elt list
let ( >@ ) x y = y @ x      
let ( >:: ) x y = y :: x
let lift : (uid * insn) list -> stream = List.rev_map (fun (x,i) -> I (x,i))

(* Build a CFG and collection of global variable definitions from a stream *)
let cfg_of_stream (code:stream) : Ll.cfg * (Ll.gid * Ll.gdecl) list  =
    let gs, einsns, insns, term_opt, blks = List.fold_left
      (fun (gs, einsns, insns, term_opt, blks) e ->
        match e with
        | L l ->
           begin match term_opt with
           | None -> 
              if (List.length insns) = 0 then (gs, einsns, [], None, blks)
              else failwith @@ Printf.sprintf "build_cfg: block labeled %s has\
                                               no terminator" l
           | Some term ->
              (gs, einsns, [], None, (l, {insns; term})::blks)
           end
        | T t  -> (gs, einsns, [], Some (Llutil.Parsing.gensym "tmn", t), blks)
        | I (uid,insn)  -> (gs, einsns, (uid,insn)::insns, term_opt, blks)
        | G (gid,gdecl) ->  ((gid,gdecl)::gs, einsns, insns, term_opt, blks)
        | E (uid,i) -> (gs, (uid, i)::einsns, insns, term_opt, blks)
      ) ([], [], [], None, []) code
    in
    match term_opt with
    | None -> failwith "build_cfg: entry block has no terminator" 
    | Some term -> 
       let insns = einsns @ insns in
       ({insns; term}, blks), gs


(* compilation contexts ----------------------------------------------------- *)

(* To compile OAT variables, we maintain a mapping of source identifiers to the
   corresponding LLVMlite operands. Bindings are added for global OAT variables
   and local variables that are in scope. *)

module Ctxt = struct

  type t = (Ast.id * (Ll.ty * Ll.operand)) list
  let empty = []

  (* Add a binding to the context *)
  let add (c:t) (id:id) (bnd:Ll.ty * Ll.operand) : t = (id,bnd)::c

  (* Lookup a binding in the context *)
  let lookup (id:Ast.id) (c:t) : Ll.ty * Ll.operand =
    try 
      List.assoc id c
    with
      Not_found -> failwith ("Tried to lookup value " ^ id ^ " but failed")

  let is_global (id:Ast.id) (c:t) : bool =
    try 
      let (ty,op) = List.assoc id c in
      match op with
      |Gid gid -> true
      |_ -> false
    with
      Not_found -> false

  (* Lookup a function, fail otherwise *)
  let lookup_function (id:Ast.id) (c:t) : Ll.ty * Ll.operand =
    match List.assoc id c with
    | Ptr (Fun (args, ret)), g -> Ptr (Fun (args, ret)), g
    | _ -> failwith @@ id ^ " not bound to a function"

  let lookup_function_option (id:Ast.id) (c:t) : (Ll.ty * Ll.operand) option =
    try Some (lookup_function id c) with _ -> None
  
end

(* compiling OAT types ------------------------------------------------------ *)

(* The mapping of source types onto LLVMlite is straightforward. Booleans and ints
   are represented as the corresponding integer types. OAT strings are
   pointers to bytes (I8). Arrays are the most interesting type: they are
   represented as pointers to structs where the first component is the number
   of elements in the following array.

   The trickiest part of this project will be satisfying LLVM's rudimentary type
   system. Recall that global arrays in LLVMlite need to be declared with their
   length in the type to statically allocate the right amount of memory. The 
   global strings and arrays you emit will therefore have a more specific type
   annotation than the output of cmp_rty. You will have to carefully bitcast
   gids to satisfy the LLVM type checker.
*)


let rec llty_to_string : Ll.ty -> string = function
| Void -> "Void"
| I1 -> "I1"
| I8 -> "I8"
| I64 -> "I64"
| Ptr (ty)-> ("Ptr ("^(llty_to_string ty)^")")
| Struct ts -> (struct_to_string (Struct ts))
| Array (i,ty) -> ("Array ["^(string_of_int i)^", "^(llty_to_string ty)^" ]")   
| Fun (tys,ty) -> failwith "fun of ty in lltytostring"
| Namedt (tid) -> failwith "namedty in lltytostring"

and tylist_to_string : Ll.ty list -> string = function
  |[] -> ""
  |t::ts -> ((llty_to_string t)^", "^(tylist_to_string ts))

and struct_to_string : Ll.ty -> string = function
  |Struct ts -> ("Struct {"^(tylist_to_string ts)^"}")

let rec cmp_ty : Ast.ty -> Ll.ty = function
  | Ast.TBool  -> I1 
  | Ast.TInt   -> I64
  | Ast.TRef r -> Ptr (cmp_rty r)

and cmp_rty : Ast.rty -> Ll.ty = function
  | Ast.RString  -> I8
  | Ast.RArray u -> Struct [I64; Array(0, cmp_ty u)]
  | Ast.RFun (ts, t) -> 
      let args, ret = cmp_fty (ts, t) in
      Fun (args, ret)

and cmp_ret_ty : Ast.ret_ty -> Ll.ty = function
  | Ast.RetVoid  -> Void
  | Ast.RetVal t -> cmp_ty t

and cmp_fty (ts, r) : Ll.fty =
  List.map cmp_ty ts, cmp_ret_ty r


let typ_of_binop : Ast.binop -> Ast.ty * Ast.ty * Ast.ty = function
  | Add | Mul | Sub | Shl | Shr | Sar | IAnd | IOr -> (TInt, TInt, TInt)
  | Eq | Neq | Lt | Lte | Gt | Gte -> (TInt, TInt, TBool)
  | And | Or -> (TBool, TBool, TBool)

let typ_of_unop : Ast.unop -> Ast.ty * Ast.ty = function
  | Neg | Bitnot -> (TInt, TInt)
  | Lognot       -> (TBool, TBool)

let op_to_string = function
  |Ll.Null -> "NULL"
  |Ll.Const i -> ("Const "^(Int64.to_string i))
  |Ll.Gid gid -> ("Gid of "^gid)
  |Ll.Id uid -> ("Uid of "^uid)

(* Compiler Invariants

   The LLVM IR type of a variable (whether global or local) that stores an Oat
   array value (or any other reference type, like "string") will always be a
   double pointer.  In general, any Oat variable of Oat-type t will be
   represented by an LLVM IR value of type Ptr (cmp_ty t).  So the Oat variable
   x : int will be represented by an LLVM IR value of type i64*, y : string will
   be represented by a value of type i8**, and arr : int[] will be represented
   by a value of type {i64, [0 x i64]}**.  Whether the LLVM IR type is a
   "single" or "double" pointer depends on whether t is a reference type.

   We can think of the compiler as paying careful attention to whether a piece
   of Oat syntax denotes the "value" of an expression or a pointer to the
   "storage space associated with it".  This is the distinction between an
   "expression" and the "left-hand-side" of an assignment statement.  Compiling
   an Oat variable identifier as an expression ("value") does the load, so
   cmp_exp called on an Oat variable of type t returns (code that) generates a
   LLVM IR value of type cmp_ty t.  Compiling an identifier as a left-hand-side
   does not do the load, so cmp_lhs called on an Oat variable of type t returns
   and operand of type (cmp_ty t)*.  Extending these invariants to account for
   array accesses: the assignment e1[e2] = e3; treats e1[e2] as a
   left-hand-side, so we compile it as follows: compile e1 as an expression to
   obtain an array value (which is of pointer of type {i64, [0 x s]}* ).
   compile e2 as an expression to obtain an operand of type i64, generate code
   that uses getelementptr to compute the offset from the array value, which is
   a pointer to the "storage space associated with e1[e2]".

   On the other hand, compiling e1[e2] as an expression (to obtain the value of
   the array), we can simply compile e1[e2] as a left-hand-side and then do the
   load.  So cmp_exp and cmp_lhs are mutually recursive.  [[Actually, as I am
   writing this, I think it could make sense to factor the Oat grammar in this
   way, which would make things clearer, I may do that for next time around.]]

 
   Consider globals7.oat

   /--------------- globals7.oat ------------------ 
   global arr = int[] null;

   int foo() { 
     var x = new int[3]; 
     arr = x; 
     x[2] = 3; 
     return arr[2]; 
   }
   /------------------------------------------------

   The translation (given by cmp_ty) of the type int[] is {i64, [0 x i64}* so
   the corresponding LLVM IR declaration will look like:

   @arr = global { i64, [0 x i64] }* null

   This means that the type of the LLVM IR identifier @arr is {i64, [0 x i64]}**
   which is consistent with the type of a locally-declared array variable.

   The local variable x would be allocated and initialized by (something like)
   the following code snippet.  Here %_x7 is the LLVM IR uid containing the
   pointer to the "storage space" for the Oat variable x.
   ---------------------------------------------------------------------------------------------
   var x = new int[3];
   ---------------------------------------------------------------------------------------------

   %_x7 = alloca { i64, [0 x i64] }*                              ;; (1)
   %_raw_array5 = call i64*  @oat_alloc_array(i64 3)              ;; (2)
   %_array6 = bitcast i64* %_raw_array5 to { i64, [0 x i64] }*    ;; (3)
   store { i64, [0 x i64]}* %_array6, { i64, [0 x i64] }** %_x7   ;; (4)

   (1) note that alloca uses cmp_ty (int[]) to find the type, so %_x7 has 
       the same type as @arr 

   (2) @oat_alloc_array allocates len+1 i64's 

   (3) we have to bitcast the result of @oat_alloc_array so we can store it
        in %_x7 

   (4) stores the resulting array value (itself a pointer) into %_x7 
  ---------------------------------------------------------------------------------------------
  The assignment arr = x; gets compiled to (something like):
  ---------------------------------------------------------------------------------------------

  %_x8 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_x7     ;; (5)
  store {i64, [0 x i64] }* %_x8, { i64, [0 x i64] }** @arr       ;; (6)

  (5) load the array value (a pointer) that is stored in the address pointed 
      to by %_x7 

  (6) store the array value (a pointer) into @arr 
---------------------------------------------------------------------------------------------
  The assignment x[2] = 3; gets compiled to (something like):
  ---------------------------------------------------------------------------------------------

  %_x9 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_x7      ;; (7)
  %_index_ptr11 = getelementptr { i64, [0 x  i64] }, 
                  { i64, [0 x i64] }* %_x9, i32 0, i32 1, i32 2   ;; (8)
  store i64 3, i64* %_index_ptr11                                 ;; (9)

  (7) as above, load the array value that is stored %_x7 

  (8) calculate the offset from the array using GEP

  (9) store 3 into the array
---------------------------------------------------------------------------------------------
  Finally, return arr[2]; gets compiled to (something like) the following.
  Note that the way arr is treated is identical to x.  (Once we set up the
  translation, there is no difference between Oat globals and locals, except
  how their storage space is initially allocated.)

  %_arr12 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** @arr    ;; (10)
  %_index_ptr14 = getelementptr { i64, [0 x i64] },                
                 { i64, [0 x i64] }* %_arr12, i32 0, i32 1, i32 2  ;; (11)
  %_index15 = load i64, i64* %_index_ptr14                         ;; (12)
  ret i64 %_index15

  (10) just like for %_x9, load the array value that is stored in @arr 

  (11)  calculate the array index offset

  (12) load the array value at the index 
---------------------------------------------------------------------------------------------
*)

(* Global initialized arrays:

  There is another wrinkle: To compile global initialized arrays like in the
  globals4.oat, it is helpful to do a bitcast once at the global scope to
  convert the "precise type" required by the LLVM initializer to the actual
  translation type (which sets the array length to 0).  So for globals4.oat,
  the arr global would compile to (something like):

  @arr = global { i64, [0 x i64] }* bitcast 
           ({ i64, [4 x i64] }* @_global_arr5 to { i64, [0 x i64] }* ) 
  @_global_arr5 = global { i64, [4 x i64] } 
                  { i64 4, [4 x i64] [ i64 1, i64 2, i64 3, i64 4 ] }

*) 



(* Some useful helper functions *)

(* Generate a fresh temporary identifier. Since OAT identifiers cannot begin
   with an underscore, these should not clash with any source variables *)
let gensym : string -> string =
  let c = ref 0 in
  fun (s:string) -> incr c; Printf.sprintf "_%s%d" s (!c)

(* Amount of space an Oat type takes when stored in the stack, in bytes.  
   Note that since structured values are manipulated by reference, all
   Oat values take 8 bytes on the stack.
*)
let size_oat_ty (t : Ast.ty) = 8L

(* Generate code to allocate a zero-initialized array of source type TRef (RArray t) of the
   given size. Note "size" is an operand whose value can be computed at
   runtime *)

let oat_alloc_array (t:Ast.ty) (size:Ll.operand) : Ll.ty * operand * stream =
  let ans_id, arr_id = gensym "array", gensym "raw_array" in
  let ans_ty = cmp_ty @@ TRef (RArray t) in
  let arr_ty = Ptr I64 in
  ans_ty, Id ans_id, lift
    [ arr_id, Call(arr_ty, Gid "oat_alloc_array", [I64, size])
    ; ans_id, Bitcast(arr_ty, Id arr_id, ans_ty) ]


let oat_alloc_str (s:string) : Ll.ty * operand * stream =
  let ans_id, str_id = gensym "string", gensym "raw_string" in
  let str_len = gensym "len" in
  let ans_ty = cmp_ty @@ TRef (RString) in
  let size = Const 3L in
  let code = [
    (* str_len, Ll.Call (I64, Gid "length_of_string", [Ptr I8, s]); *)
    str_id , Ll.Call (Ptr I8, Gid "oat_alloc_array", [I8, Id str_len]);
    ans_id , Bitcast(Ptr I8, Id str_id, ans_ty)] in
  (ans_ty, Id ans_id, (lift code))


(* Compiles an expression exp in context c, outputting the Ll operand that will
   recieve the value of the expression, and the stream of instructions
   implementing the expression. 

   Tips:
   - use the provided cmp_ty function!

   - string literals (CStr s) should be hoisted. You'll need to make sure
     either that the resulting gid has type (Ptr I8), or, if the gid has type
     [n x i8] (where n is the length of the string), convert the gid to a 
     (Ptr I8), e.g., by using getelementptr.

   - use the provided "oat_alloc_array" function to implement literal arrays
     (CArr) and the (NewArr) expressions

*)


   
  
(* 
   Struct [I64; Array(0, cmp_ty u)] 
   *)

let rec get_ty_from_structptr (structptrty : Ll.ty) : Ll.ty =
  let Ptr (structty) = structptrty in
  (* print_endline "cracked ptr -> struct"; *)
  let Struct (t1::arr::ts) = structty in
  (* print_endline "cracked struct -> type::arr::_"; *)
  let Array (l, arrty) = arr in
  (* print_endline "cracked arr -> l,arrty"; *)
  match arrty with
    |Ptr (t) -> get_ty_from_structptr arrty
    |_ -> arrty

  let  get_ty_from_structptr_once (structptrty : Ll.ty) : Ll.ty =
    let structty = match structptrty with
      |Void -> failwith "trying to get_ty_from_structptr_once on void"
      |I1 -> failwith "trying to get_ty_from_structptr_once on i1"
      |I8 -> failwith "trying to get_ty_from_structptr_once on i8"
      |I64 -> failwith "trying to get_ty_from_structptr_once on i64"
      |Ptr (structty) -> structty
      |Struct (ts) ->  structptrty
      |Array (l, arrty) -> failwith "trying to get_ty_from_structptr_once on array"
      |Fun (tys,ty) -> failwith "trying to get_ty_from_structptr_once on fun"
      |Namedt (tid) -> failwith "trying to get_ty_from_structptr_once on namedt"
      |_ -> failwith "trying to get_ty_from_structptr_once on non ptr" in
    (* let Ptr (structty) = structptrty in *)
    let Struct (t1::arr::ts) = structty in
    let Array (l, arrty) = arr in
    (arrty)
  
  


let simple_hash_helper str =
  let rec aux acc i =
    if i < String.length str then
      let char_code = int_of_char str.[i] in
      let new_acc = (acc lsl 1) lxor char_code in (* Shift and xor with char code *)
      aux new_acc (i + 1)
    else
      acc
  in
  aux 0 0
  |> string_of_int  (* Convert the final integer to a string *)

let simple_hash str =
  ("hash" ^ simple_hash_helper str)


let rec cmp_exp (c:Ctxt.t) (expnd:Ast.exp node) : Ll.ty * Ll.operand * stream =
  let {elt=exp;loc} = expnd in
  begin match exp with
    | CNull (ty) -> failwith "trying to compile null"
    | CBool true -> (Ll.I1, (Const 1L), []) 
    | CBool false -> (Ll.I1, (Const 0L), [])
    | CInt i -> (Ll.I64, (Const i), [])
    | CStr s -> 
      (* let lluid = gensym s in 
      let (ty,op,str) = oat_alloc_str(s) in *)
      (* cmp_exp c ({elt = (Id s);loc=loc}) *)
      (* let (ty,op) = Ctxt.lookup s c in   *)
      let typeOfStr = Array((String.length s) + 1, I8) in
       
      let ptrToString = gensym "ptrToString" in
      let castedStr = gensym "castedStr" in
      (* let str = [G (simple_hash s, (typeOfStr, GString s))] in *)
      let str = [I (ptrToString, Gep (Ptr typeOfStr, Ll.Gid (simple_hash s), [(Const 0L);(Const 0L)]))] in
      (*let str = str >@ [I (castedStr, Bitcast (Ptr typeOfStr, Id ptrToString, Ptr I8))] in *)
      (Ptr I8, Ll.Id ptrToString ,str)
      (* (cmp_exp c {(array_of_string(s)))(Ptr (I8), Const 1L , []) *)

    | CArr (arrty,exps) -> 
      let rec allocate_arrays arrty (exps : Ast.exp node list) : Ll.ty * Ll.operand * stream = 
        let length = List.length exps in
        let (ty, op, init_str) = oat_alloc_array arrty (Const (Int64.of_int length)) in
        let final_str = ref init_str in
        for i = 0 to (length-1) do
          let {elt=currExp;} = List.nth exps i in
          let (currTy, currOp, currStr) = match currExp with
            | CArr (ty, expnd) -> allocate_arrays ty expnd
            | exp -> cmp_exp c (List.nth exps i) in
          let gepid = gensym "getpointer" in
          final_str := !final_str >@ currStr >@ [I (gepid, (Gep (ty, op, [(Const 0L);(Const (1L));(Const (Int64.of_int i))])))];
          final_str := !final_str >@ [I ("", Store (currTy, currOp, Id gepid))];
        done;
        (ty, op, !final_str)
      in
      let gepidLength = gensym "getpointerLength" in

      let (ty, op, str) = allocate_arrays arrty exps in
      (* let str = str >@ [I (gepidLength, (Gep (ty, op ,[(Const 0L);(Const 0L)])))] in
      let str = str >@ [I ("", Store (I64, Const (Int64.of_int (List.length exps)), Id gepidLength))] in *)
      (ty,op,str)
    

    | NewArr (arrty, expnd) ->
      let {elt=exp} = expnd in
      let (_,lengthop,lengthstr) = cmp_exp c expnd in  (* REMOVED HARDCODED CINT*)
      let (ty, op, str) = oat_alloc_array arrty lengthop in
      (ty,op,lengthstr >@ str)

    | Id id -> 
      let (ty, op) = (Ctxt.lookup id c) in
      begin match ty with
        |Ptr (ptrty) ->
          let lluid1 = gensym "" in 
          let code = [I (lluid1, Load (ty, op))] in
          (ptrty,Ll.Id lluid1 ,code)    (*this also needs to be accessed if its rhs*)
        |Struct (ts) ->
          let lluid1 = gensym "" in 
          let code = [I (lluid1, Load (Ptr ty, op))] in
          (Ptr ty, op ,code)    (*this also needs to be accessed if its rhs*)
        |Array (l,arrty) -> 
          (ty, op, [])
        |_ -> failwith ("trying to compile id that is not a pointer but actually is " ^ (llty_to_string ty))
      end

    |Index (expnd1, expnd2) -> cmp_index c expnd1 expnd2 



    | Call (expnd,expnds) -> cmp_call c expnd expnds
    | Bop (bop, expnd1, expnd2) ->  cmp_bop c bop expnd1 expnd2
    | Uop (unop, expnd1) -> cmp_uop c unop expnd1
  end


  and cmp_lhs (c:Ctxt.t) (expnd:Ast.exp node) : Ll.ty * Ll.operand * stream =
    let {elt=exp;} = expnd in
      match exp with
      | CNull rty -> failwith "trying to store to nullpointer"
      | CInt i -> cmp_exp c expnd 
      | Id id -> 
        let (ty,op) = (Ctxt.lookup id c) in
        (ty,op,[])
      | Index (ptr,ind) -> 
        let (structty,structop,loadstr) = cmp_exp c ptr in
        let tempSym = gensym "temp" in
        
        let (_, indop, indstr) = cmp_exp c ind in 
        let (extractedty, ops, extractty, extractop, includeLoad) = match structty with
          | Ptr ( Struct x) -> ((get_ty_from_structptr_once structty),[(Const 0L);(Const 1L);indop],structty,structop, loadstr)
          | Ptr ( Array (l,arrty)) -> failwith ("cmp_index: structty is Ptr to Array")
          | Ptr x -> failwith ("cmp_index: structty is ptr")
          | Struct x ->
            let (Id extractId) = ptr.elt in
            let (ty, extractId) = (Ctxt.lookup extractId c) in
            ((get_ty_from_structptr_once (Ptr structty)),[(Const 0L);(Const 1L);indop],Ptr structty,Ll.Id tempSym,[I (tempSym, Load (Ptr (Ptr structty), extractId))])
          | Array (l,arrty) ->
            let (Id extractId) = ptr.elt in
            let (ty, extractId) = (Ctxt.lookup extractId c) in
            (arrty,[(Const 0L);indop],Ptr structty,extractId,[])
          | _ -> failwith ("cmp_index: structty is not ptr") in
      
        let gepid = gensym "getpointer" in
        let strGep = [I (gepid, (Gep (extractty, extractop, ops)))] in
        (Ptr extractedty , Id gepid,   indstr >@ includeLoad >@ strGep)
  
      |_ -> failwith "trying to cmp_lhs with invalid type "
    
and cmp_index (c:Ctxt.t) (ptr:Ast.exp node) (ind:Ast.exp node): Ll.ty * Ll.operand * stream =
    let (structty,structop,loadstr) = cmp_exp c ptr in
    let tempSym = gensym "temp" in
    
    let (_, indop, indstr) = cmp_exp c ind in 
    let (extractedty, ops, extractty, extractop, includeLoad) = match structty with
      | Ptr ( Struct x) -> ((get_ty_from_structptr_once structty),[(Const 0L);(Const 1L);indop],structty,structop, loadstr)
      | Ptr ( Array (l,arrty)) -> failwith ("cmp_index: structty is Ptr to Array")
      | Ptr x -> failwith ("cmp_index: structty is ptr")
      | Struct x ->
        let (Id extractId) = ptr.elt in
        let (ty, extractId) = (Ctxt.lookup extractId c) in
        ((get_ty_from_structptr_once (Ptr structty)),[(Const 0L);(Const 1L);indop],Ptr structty,Ll.Id tempSym,[I (tempSym, Load (Ptr (Ptr structty), extractId))])
      | Array (l,arrty) ->
        let (Id extractId) = ptr.elt in
        let (ty, extractId) = (Ctxt.lookup extractId c) in
        (arrty,[(Const 0L);indop],Ptr structty,extractId,[])
      | _ -> failwith ("cmp_index: structty is not ptr") in
   
    let gepid = gensym "getpointer" in
    let strGep = [I (gepid, (Gep (extractty, extractop, ops)))] in
    let indexid = gensym "index" in
    let strLoad = [I (indexid, Load ((* added "Ptr" -->*) Ptr extractedty, Id gepid)) ] in
    (extractedty , Id indexid,   indstr >@ includeLoad >@ strGep >@ strLoad )


and cmp_carr_init (c:Ctxt.t) (arrtype:Ast.ty) (expnds:(Ast.exp node) list) : Ll.ty * Ll.operand * stream =
    let length = List.length expnds in
    let (ty, op, str) = oat_alloc_array arrtype (Const (Int64.of_int length)) in
    let llarrty = cmp_ty arrtype in
    let (recty,recop,recstr) = cmp_carr_rec c llarrty op expnds in 
    (ty,op,str)
    
and cmp_carr_rec (c:Ctxt.t) (arrtype:Ll.ty) (op:Ll.operand) (expnds:(Ast.exp node) list) : Ll.ty * Ll.operand * stream =
    failwith "cmp_carr_rec not imp yet"

and cmp_call (c:Ctxt.t) (expnd:Ast.exp node) (expnds:Ast.exp node list) : Ll.ty * Ll.operand * stream =
  let rec cmp_fargs (c:Ctxt.t) (expnodes:Ast.exp node list) (str:stream) (ty_ops_of_params:(Ll.ty * Ll.operand) list) : Ctxt.t * stream * (Ll.ty * Ll.operand) list =
    match expnodes with
      |[] -> (c,str,ty_ops_of_params)
      |(expnd::expnds) ->  
        let {elt=exp} = expnd in
        let (llty, llop, exp_str) = cmp_exp c expnd in
        cmp_fargs c expnds (exp_str >@ str) (ty_ops_of_params @ [(llty,llop)])
    in 

    let {elt= idid} = expnd in
    let Id (id) = idid in (* shoudld be id of function*)
    let (newc, str, tyops) = cmp_fargs c expnds [] [] in
    let (ty, gid) = Ctxt.lookup_function id c in
    let Ptr (Fun (args, ret)) = ty in
    let lluid = gensym id in
    let str = str >@ [ I (lluid, Call (ret, gid, tyops))] in
    (ret , Ll.Id lluid , str)


and cmp_bop (c:Ctxt.t) (bop:Ast.binop) (expnd1:Ast.exp node) (expnd2:Ast.exp node) : Ll.ty * Ll.operand * stream =
  let (t1,op1,str1) = cmp_exp c expnd1 in 
  let (t2,op2,str2) = cmp_exp c expnd2 in
  let lluid = (gensym "") in 
    match bop with
    | Add -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Add, Ll.I64, op1, op2)))] )
    | Sub -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Sub, Ll.I64, op1, op2)))] )
    | Mul -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Mul, Ll.I64, op1, op2)))] )
    | Eq  -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Icmp (Ll.Eq, Ll.I64, op1, op2)))] )
    | Neq -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Icmp (Ll.Ne, Ll.I64, op1, op2)))] )
    | Lt -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Icmp (Ll.Slt, Ll.I64, op1, op2)))] )
    | Lte -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Icmp (Ll.Sle, Ll.I64, op1, op2)))] )
    | Gt -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Icmp (Ll.Sgt, Ll.I64, op1, op2)))] )
    | Gte -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Icmp (Ll.Sge, Ll.I64, op1, op2)))] ) (*GreaterEq currently sgt*)
    | And -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.And, Ll.I1, op1, op2)))] )
    | Or -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Or, Ll.I1, op1, op2)))] )
    | IAnd -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.And, Ll.I64, op1, op2)))] )
    | IOr -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Or, Ll.I64, op1, op2)))] )
    | Shl -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Shl, Ll.I64, op1, op2)))] )
    | Shr -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Lshr, Ll.I64, op1, op2)))] )
    | Sar -> (Ll.I64, Ll.Id (lluid), str1 >@ str2 >@ [I (lluid, (Binop (Ll.Ashr, Ll.I64, op1, op2)))] )

and cmp_uop (c:Ctxt.t) (uop:Ast.unop) (expnd:Ast.exp node) : Ll.ty * Ll.operand * stream =
    let {elt= exp;} = expnd in
    let (t,op,str) = cmp_exp c expnd in
    let lluid = (gensym "") in 
    match uop with
    | Neg -> (Ll.I64, Ll.Id (lluid), str >@ [I (lluid, (Binop (Ll.Mul, Ll.I64, Const (-1L), op )))])
    | Lognot -> (Ll.I1, Ll.Id (lluid), str >@ [I (lluid, (Binop (Ll.Xor, Ll.I1, Const (1L), op  )))])
    | Bitnot -> (Ll.I64, Ll.Id (lluid), str >@ [I (lluid, (Binop (Ll.Xor, Ll.I64, Const (0xFFFFFFFFFFFFFFFFL), op  )))])


(* Compile a statement in context c with return typ rt. Return a new context, 
   possibly extended with new local bindings, and the instruction stream
   implementing the statement.

   Left-hand-sides of assignment statements must either be OAT identifiers,
   or an index into some arbitrary expression of array type. Otherwise, the
   program is not well-formed and your compiler may throw an error.

   Tips:
   - for local variable declarations, you will need to emit Allocas in the
     entry block of the current function using the E() constructor.

   - don't forget to add a bindings to the context for local variable 
     declarations
   
   - you can avoid some work by translating For loops to the corresponding
     While loop, building the AST and recursively calling cmp_stmt

   - you might find it helpful to reuse the code you wrote for the Call
     expression to implement the SCall statement

   - compiling the left-hand-side of an assignment is almost exactly like
     compiling the Id or Index expression. Instead of loading the resulting
     pointer, you just need to store to it!

 *)

(*| Assn of exp node * exp node
  | Decl of vdecl
  | Ret of exp node option
  | SCall of exp node * exp node list
  | If of exp node * stmt node list * stmt node list
  | For of vdecl list * exp node option * stmt node option * stmt node list
  | While of exp node * stmt node list*)
let cmp_assn (c:Ctxt.t) (expnd1:Ast.exp node) (expnd2:Ast.exp node) : Ctxt.t * stream =
  let (t1,op1,str1) = cmp_lhs c expnd1 in

  let (t2,op2,str2) = cmp_exp c expnd2 in
  let code = str1 >@ str2 in
  let lluid2 = gensym "" in

  let code = code >@ [I (lluid2, Store (t2, op2, op1))] in
  (c,code)

  


(* let add (c:t) (id:id) (bnd:Ll.ty * Ll.operand) : t = (id,bnd)::c *)

let cmp_decl (c:Ctxt.t) (vdecl:vdecl) : Ctxt.t * stream = 
  let (id, expnd) = vdecl in
  let lluid = gensym id in
  let (llexpty, llop, stream) = cmp_exp c expnd in
  let newCtxt = Ctxt.add c id (Ll.Ptr llexpty, Ll.Id lluid) in
  let ins1 = [I (lluid , Alloca (llexpty))] in
  let ins2 = [I (lluid, Store (llexpty, llop, Ll.Id lluid))] in
  (newCtxt,  ins1 >@ stream >@ ins2)


let cmp_ret (c:Ctxt.t) (rt:Ll.ty) (expnd:Ast.exp node) : stream = 
  let {elt=exp;} = expnd in
  match exp with
  | CNull (ty) -> let (ty, op, str) = cmp_exp c expnd in 
    str >@ [T (Ll.Ret (rt, Some (op)))]
  | CBool true -> [T (Ll.Ret (rt, Some (Const 1L)))]
  | CBool false -> [T (Ll.Ret (rt, Some (Const 0L)))]
  | CInt i -> [T (Ll.Ret (rt, Some (Const i)))]
  | CStr s -> let (ty, op, str) = cmp_exp c expnd in 
    str >@ [T (Ll.Ret (rt, Some (op)))]
  | CArr (ty,exps) -> let (ty, op, str) = cmp_exp c expnd in 
    str >@ [T (Ll.Ret (rt, Some (op)))]
  | Id id -> let (ty, op, str) = cmp_exp c expnd in 
    str >@ [T (Ll.Ret (rt, Some (op)))]
    (* [T (Ll.Ret (rt, Some (snd (Ctxt.lookup id c))))] *)
  | Index ({elt=ex1;}, {elt=ex2;}) -> 
      let (ty,op,str) = cmp_exp c expnd in
      let str = str >@ [T (Ll.Ret (rt, Some op))] in
      (str)
  | Call ({elt=ex1;},exps) -> 
    let (ty,op,str) = cmp_exp c expnd in
    (str >@ [T (Ll.Ret (rt, Some op))])  
  | Bop (bop, {elt=ex1;}, {elt=ex2;}) -> 
    let (ty,op,str) = cmp_exp c expnd in
    str >@  [T (Ll.Ret (rt, Some op)) ]

  | Uop (unop, {elt=ex1;}) -> let (ty, op, str) = cmp_exp c expnd in 
    str >@ [T (Ll.Ret (rt, Some (op)))]
 


let cmp_if (c:Ctxt.t) (expnd : exp node) ((cTrue,strTrue) : (Ctxt.t * stream)) ((cFalse, strFalse) : (Ctxt.t * stream)) : Ctxt.t * stream =
  let (llexpty, llop, str) = cmp_exp c expnd in
  (* let cmplluid = gensym "cmp" in *)
  let lblthen = gensym "then" in
  let lblelse = gensym "else" in
  let lblend = gensym "end" in

  (*IFSTMNT*)
  let code = [T (Cbr (llop, lblthen, lblelse))] in
  (*THEN*)
  let code = code >@ [L lblthen] in
  let code = code >@ strTrue in
  let code = code >@ [T (Br lblend)] in
  (*ELSE*)
  let code = code >@ [L lblelse] in
  let code = code >@ strFalse in
  let code = code >@ [T (Br lblend)] in
  (*END*)
  let code = code >@ [L lblend] in
  (c, str >@ code)




let cmp_while (c:Ctxt.t) (bexp:Ast.exp node option) (_,str_of_stmts:(Ctxt.t * stream)) : Ctxt.t * stream =
let (ty,op,bool_eval) = match bexp with
  | Some bexp -> cmp_exp c bexp
  | None -> (Ll.I1, Ll.Const 1L, []) in

let loop = gensym "loop" in
let cond = gensym "cond" in
let escape = gensym "end" in

let code =         
   [T (Br cond)]
>@ [L loop]
>@ str_of_stmts 
>@ [T (Br cond)] 
>@ [L cond] 
>@ bool_eval 
>@ [T (Cbr (op,loop,escape))] 
>@ [L escape] in
(c, code)

let rec cmp_fargs (c:Ctxt.t) (expnodes:Ast.exp node list) (str:stream) (ty_ops_of_params:(Ll.ty * Ll.operand) list) : Ctxt.t * stream * (Ll.ty * Ll.operand) list =
  match expnodes with
    |[] -> (c,str,ty_ops_of_params)
    |(expnd::expnds) ->  
      let {elt=exp} = expnd in
      let (llty, llop, exp_str) = cmp_exp c expnd in
      cmp_fargs c expnds (exp_str >@ str) (ty_ops_of_params @ [(llty,llop)]) 
  

let cmp_scall (c:Ctxt.t) (expnd:Ast.exp node) (expnds:Ast.exp node list) : Ctxt.t * stream = 
let {elt= idid} = expnd in
let Id (id) = idid in (* shoudld be id of function*)
let (newc, str, tyops) = cmp_fargs c expnds [] [] in
(* let lluid = gensym id in *)
let str = str >@ [I ( "", (Call (Ll.Void, Ll.Gid id, tyops)))] in
(c,str)


let rec cmp_stmt (c:Ctxt.t) (rt:Ll.ty) (stmt:Ast.stmt node) : Ctxt.t * stream =
  let {elt;} = stmt in 
  match elt with
  | Assn (lhs,rhs) -> cmp_assn c lhs rhs
  | Decl (vdecl) -> cmp_decl c vdecl
  | Ast.Ret Some exp -> (c, cmp_ret c rt exp)
  | Ast.Ret None -> (c, [T (Ll.Ret (rt, None))])
  | SCall (ex,exs) -> cmp_scall c ex exs
  | If (ex, stmtstrue, stmtsfalse) -> cmp_if c ex (cmp_block c rt stmtstrue) (cmp_block c rt stmtsfalse)
  (*| For (vdecls , expopt,  stmtopt, stmts) -> cmp_for c vdecls expopt stmtopt rt (cmp_block c rt stmts) *)
  | For (vdecls , expopt,  stmtopt, stmts) -> cmp_for c vdecls expopt stmtopt rt stmts
  | While (ex , stmts) -> cmp_while c (Some ex) (cmp_block c rt stmts) 


and cmp_for (c:Ctxt.t) (vdecls:Ast.vdecl list) (expnd:Ast.exp node option) (stmtnd:stmt node option) (rt:Ll.ty) (stmts : stmt node list) : Ctxt.t * stream =
  let rec cmp_vdecls (c:Ctxt.t) (vdecls:Ast.vdecl list) : Ctxt.t * stream =
    match vdecls with
      |[] -> (c,[])
      |vdecl::vdecls -> let (c,str) = cmp_decl c vdecl in
      let (c,strs) = cmp_vdecls c vdecls in
      (c, str >@ strs) in
  
  let (c,vdecls_code) = cmp_vdecls c vdecls in

  let (c,while_code) = match stmtnd with 
    |Some stmt -> 
      let (c,stmts_code) = cmp_block c rt stmts in
      let (c,stmt_code) = cmp_stmt c rt stmt in
      cmp_while c expnd (c,(stmts_code >@ stmt_code))
    |None -> cmp_while c expnd (cmp_block c rt stmts)  in
  (c, vdecls_code >@ while_code)



(* and cmp_for_lars (c:Ctxt.t) (vdecls:Ast.vdecl list) (expnd:Ast.exp node option) (stmtnd:stmt node option) (rt:Ll.ty) (_,str_of_stmts:(Ctxt.t * stream)) : Ctxt.t * stream =
    let init = gensym "init" in
    let loop = gensym "loop" in
    let cond = gensym "cond" in
    let escape = gensym "end" in

    let vdeclstr = List.flatten (List.map (snd) (List.map (cmp_decl c) vdecls)) in
    
    let incrstr = match stmtnd with 
      |Some incr -> let (c,str) = cmp_stmt c rt incr in
      (str) 
      |None -> []
    in
    
    let condstr = match expnd with 
      |Some bexp -> let (ty,op,str) = cmp_exp c bexp in
      (str >@ [T (Cbr (op, loop, escape))])
      |None -> [T (Br escape)]
    in

    let code = [] in 
    let code = code >@ [L init] in
    (* let code = code >@ [vdeclstr] in *)
    let code = code >@ [T (Br cond)] in
    let code = code >@ [L loop] in
    (* let code = code >@ str_of_stmts in *)
    (* let code = code >@ incrstr in *)
    let code = code >@ [T (Br cond)] in
    let code = code >@ [L cond] in
    (* let code = code >@ condstr in  *) let code = code >@ [T (Br escape)] in 
    let code = code >@ [L escape] in
    let code = [] in 
    (c, code) *)




(* Compile a series of statements *)
and cmp_block (c:Ctxt.t) (rt:Ll.ty) (stmts:Ast.block) : Ctxt.t * stream =
  List.fold_left (fun (c, code) s -> 
      let c, stmt_code = cmp_stmt c rt s in
      c, code >@ stmt_code
    ) (c,[]) stmts



(* Adds each function identifer to the context at an
   appropriately translated type.  

   NOTE: The Gid of a function is just its source name
*)
let cmp_function_ctxt (c:Ctxt.t) (p:Ast.prog) : Ctxt.t =
    List.fold_left (fun c -> function
      | Ast.Gfdecl { elt={ frtyp; fname; args } } ->
         let ft = TRef (RFun (List.map fst args, frtyp)) in
         Ctxt.add c fname (cmp_ty ft, Gid fname)
      | _ -> c
    ) c p 

(* Populate a context with bindings for global variables 
   mapping OAT identifiers to LLVMlite gids and their types.

   Only a small subset of OAT expressions can be used as global initializers
   in well-formed programs. (The constructors starting with C). 
*)
let cmp_global_ctxt (c:Ctxt.t) (p:Ast.prog) : Ctxt.t =
    List.fold_left (fun c -> function
      | Ast.Gvdecl {elt = {name=gdecl_name; init={elt=expression;loc}}} ->
        (* let ll_name = gensym gdecl_name in *)
        begin match expression with
          |CNull rty -> Ctxt.add c gdecl_name (cmp_rty rty, Ll.Null) (*NULLPOINTER, NOW JUST LABELED WITH TYPE*)
          |CBool b -> Ctxt.add c gdecl_name (Ptr Ll.I1, Gid gdecl_name)
          |CInt i ->  Ctxt.add c gdecl_name (Ptr Ll.I64, Gid gdecl_name)
          |CStr s -> Ctxt.add c gdecl_name (Ptr Ll.I8, Gid gdecl_name)
          |CArr (a,expnodelist) -> 
            let length = List.length expnodelist in
            Ctxt.add c gdecl_name (Ptr (Struct [I64 ;(Array (0, cmp_ty a))]), Gid gdecl_name)(* needs recursive compilation of expressions, cause array of array of array... Ctxt.add c gdecl_name (Ll.I64, Gid gdecl_name) *)
          |_ -> failwith "unexpected expression in cmp_global_ctxt"  
        end
      |_ -> c
      ) c p 

(* Compile a function declaration in global context c. Return the LLVMlite cfg
   and a list of global declarations containing the string literals appearing
   in the function.

   You will need to
   1. Allocate stack space for the function parameters using Alloca
   2. Store the function arguments in their corresponding alloca'd stack slot
   3. Extend the context with bindings for function variables
   4. Compile the body of the function using cmp_block
   5. Use cfg_of_stream to produce a LLVMlite cfg from 
 *)
let rec updatectxt (c:Ctxt.t) (aids:Ast.id list) (lltys:Ll.ty list) (str: stream): Ctxt.t  * stream =
  match aids,lltys with
    |(ai::ais, ty::tys) -> 
      let newuid = gensym ("new"^ai) in
      let str = str >@ [E (newuid, (Alloca ty))] 
                >@ [E ( "" , Store (ty, Id ai , Id newuid) )] in 
      (updatectxt (Ctxt.add c ai (Ll.Ptr ty, Id newuid)) ais tys str) 
      
    |[],[] -> (c, str)
    |_ -> failwith "variable list lengths in updatectxt"
  
let rec printuids (uids:Ll.uid list) : unit =
  match uids with 
    |[] -> ()
    |uid::uids ->   printuids uids

let cmp_args (c:Ctxt.t) (args: (Ast.ty * Ast.id) list) : Ll.uid list = 
  (List.map (fun x -> (snd x)) args)

let cmp_argtypes (c:Ctxt.t)(frtyp:ret_ty)(args:(Ast.ty * Ast.id) list) : (Ll.ty list * Ll.ty) = 
  (List.map (fun x -> cmp_ty (fst x)) args, cmp_ret_ty frtyp)

let rec filter_explist_for_strings (c:Ctxt.t) (fname:string) (expnds:Ast.exp node list) : Ctxt.t * (Ll.gid * Ll.gdecl) list =
  begin match expnds with
  |[] -> c,[]  
  |expn::expns -> 
    let {elt=exp} = expn in
    begin match exp with
      |CStr s -> 
        let gid = s in 
        let len = String.length s in
        let nc,rest = (filter_explist_for_strings c fname expns) in 
        let nc = Ctxt.add nc s (Array (len+1, I8) , Gid s) in
        (* print_endline ("During: Context has size "^(string_of_int (List.length nc))); *)
        nc, ((simple_hash s), (Array (len+1, I8), GString s)) :: rest
      |CArr (ty,expnds) -> 
        let c,arrgdecls = filter_explist_for_strings c fname expnds in
        let c,restgdecls = (filter_explist_for_strings c fname expns) in
        (c,arrgdecls @ restgdecls)
      |Call (expnd,expnds) -> 
        let c,callgdecls = filter_explist_for_strings c fname expnds in
        let c,restgdecls = (filter_explist_for_strings c fname expns) in
        (c,callgdecls @ restgdecls)
      |_ -> (filter_explist_for_strings c fname expns)
    end
  end

let rec filter_stmt_for_strings (c:Ctxt.t) (fname:string) (stmt:Ast.stmt node) : Ctxt.t * (Ll.gid * Ll.gdecl) list =
  let {elt;} = stmt in 
  match elt with
  | Assn (lhs,rhs) -> filter_explist_for_strings c fname [rhs]
  | Decl (id,expnd) -> filter_explist_for_strings c fname [expnd]
  | Ast.Ret Some exp -> filter_explist_for_strings c fname [exp]
  | Ast.Ret None -> c,[]
  | SCall (ex,exs) -> filter_explist_for_strings c fname exs 
  | If (ex, stmtstrue, stmtsfalse) -> c,[]
  (*| For (vdecls , expopt,  stmtopt, stmts) -> cmp_for c vdecls expopt stmtopt rt (cmp_block c rt stmts) *)
  | For (vdecls , expopt,  stmtopt, stmts) -> 
    let c,gdecls = match stmtopt with
      |Some st -> filter_stmt_for_strings c fname st
      |None -> c,[]
    in
    let c,gdecexps = (filter_explist_for_strings c fname (List.map snd vdecls) ) in
    let c,gdecstm = (filter_stmts_for_strings c fname stmts) in
    c, gdecls @ gdecexps @ gdecstm
  | While (ex , stmts) -> filter_stmts_for_strings c fname stmts

and filter_stmts_for_strings (c:Ctxt.t) (fname:string) (stmts:Ast.stmt node list) : Ctxt.t * (Ll.gid * Ll.gdecl) list =
  match stmts with
  |[] -> c,[]
  |stmt::stms -> 
    let c,gdecstm = (filter_stmt_for_strings c fname stmt) in
    let c,gdecstms = (filter_stmts_for_strings c fname stms) in
    c, gdecstm @ gdecstms


let cmp_fdecl (c:Ctxt.t) (f:Ast.fdecl node) : Ll.fdecl * (Ll.gid * Ll.gdecl) list =
  let {elt} = f in (*elt:: fdecl*)
  let {frtyp;fname;args;body} = elt in
  let lltypes = cmp_argtypes c frtyp args in  (*(parametertypes, returntype)*)
  let lluids = cmp_args c args in           (*uids of args in llvm*)
  (* print_endline ("Before Context has size "^(string_of_int (List.length c))); *)
  let c,gdecls = filter_stmts_for_strings c fname body in
  (* print_endline ("After Context has size "^(string_of_int (List.length c))); *)
  (* let _ = printuids lluids in  *)
  let (c,str)  = updatectxt c (List.map snd args) (fst lltypes) [] in
  let (c,elelist) = cmp_block (c) (cmp_ret_ty frtyp) (body) in
  let str = str >@ elelist in
  let (llcfg,gidgdecls) = cfg_of_stream str in
  ({f_ty = lltypes; f_param = lluids; f_cfg = llcfg}, gdecls)
  
  (* failwith "cmp_fdecl not implemented" *)

(* Compile a global initializer, returning the resulting LLVMlite global
   declaration, and a list of additional global declarations.

   Tips:
   - Only CNull, CBool, CInt, CStr, and CArr can appear as global initializers
     in well-formed OAT programs. Your compiler may throw an error for the other
     cases

   - OAT arrays are always handled via pointers. A global array of arrays will
     be an array of pointers to arrays emitted as additional global declarations.
*)

let rec cmp_gexp c (e:Ast.exp node) : Ll.gdecl * (Ll.gid * Ll.gdecl) list =
  let {elt=exp;loc} = e in
    match exp with
    |CNull rty -> ((cmp_rty rty, GNull), []) (*NULLPOINTER, NOW JUST LABELED WITH TYPE*)
    |CBool false -> ((Ll.I1, GInt 0L), [])
    |CBool true -> ((Ll.I1, GInt 1L), [])
    |CInt i -> ((Ll.I64, GInt i), [])
    |CStr s -> 
      let len = String.length s in
      ((Array (len+1, I8), GString s), [])

    |CArr (ty,expnodelist) ->
      let rec allocate_global_arrays arrty expnodels : Ll.gdecl * (Ll.gid * Ll.gdecl) list =
        let length = List.length expnodels in
        let final_list = ref [] in
        for i = 0 to (length-1) do
          let {elt=currExp;} = List.nth expnodels i in
          match currExp with
            | CInt i -> final_list := !final_list @ [(I64, GInt i)]
            | exp -> failwith "unexpected expression in cmp_gexp"
        done;
        if (expnodelist == []) then 
          ((Ptr (Struct [I64 ;(Array (0, cmp_ty arrty))]), GNull), [])
        else
          let actualId = gensym "actual" in
          ((Ptr (Struct [I64 ;(Array (0, cmp_ty arrty))]),
          GBitcast (Ptr (Struct [I64 ;(Array (length, cmp_ty arrty))]), GGid actualId, (Ptr (Struct [I64 ;(Array (0, cmp_ty arrty))])))),
          [(actualId,((Struct [I64 ;(Array (length, cmp_ty arrty))]),
          (GStruct [(I64,GInt (Int64.of_int length)); (Array (length, cmp_ty arrty),GArray !final_list)])))])
      in
      allocate_global_arrays ty expnodelist
      (*let len = List.length expnodelist in
      (((Array (len, cmp_ty ty)), GArray [(I64, GInt 1L);(I64, GInt 2L);(I64, GInt 3L)]), []) *)
      
    |_ -> failwith "unexpected type in cmp_gexp "

(* CArr (arrty,exps) -> 
      let rec allocate_arrays arrty (exps : Ast.exp node list) : Ll.ty * Ll.operand * stream = 
        let length = List.length exps in
        let (ty, op, init_str) = oat_alloc_array arrty (Const (Int64.of_int length)) in
        let final_str = ref init_str in
        for i = 0 to (length-1) do
          let {elt=currExp;} = List.nth exps i in
          let (currTy, currOp, currStr) = match currExp with
            | CArr (ty, expnd) -> allocate_arrays ty expnd
            | exp -> cmp_exp c (List.nth exps i) in
          let gepid = gensym "getpointer" in
          final_str := !final_str >@ currStr >@ [I (gepid, (Gep (ty, op, [(Const 0L);(Const (1L));(Const (Int64.of_int i))])))];
          final_str := !final_str >@ [I ("", Store (currTy, currOp, Id gepid))];
        done;
        (ty, op, !final_str)
      in
      let (ty, op, str) = allocate_arrays arrty exps in
      (ty,op,str)
      *)

(* Oat internals function context ------------------------------------------- *)
let internals = [
    "oat_alloc_array",         Ll.Fun ([I64], Ptr I64)
  ]

(* Oat builtin function context --------------------------------------------- *)
let builtins =
  [ "array_of_string",  cmp_rty @@ RFun ([TRef RString], RetVal (TRef(RArray TInt)))
  ; "string_of_array",  cmp_rty @@ RFun ([TRef(RArray TInt)], RetVal (TRef RString))
  ; "length_of_string", cmp_rty @@ RFun ([TRef RString],  RetVal TInt)
  ; "string_of_int",    cmp_rty @@ RFun ([TInt],  RetVal (TRef RString))
  ; "string_cat",       cmp_rty @@ RFun ([TRef RString; TRef RString], RetVal (TRef RString))
  ; "print_string",     cmp_rty @@ RFun ([TRef RString],  RetVoid)
  ; "print_int",        cmp_rty @@ RFun ([TInt],  RetVoid)
  ; "print_bool",       cmp_rty @@ RFun ([TBool], RetVoid)
  ]

(* Compile a OAT program to LLVMlite *)
let cmp_prog (p:Ast.prog) : Ll.prog =
  (* add built-in functions to context *)
  let init_ctxt = 
    List.fold_left (fun c (i, t) -> Ctxt.add c i (Ll.Ptr t, Gid i))
      Ctxt.empty builtins
  in
  let fc = cmp_function_ctxt init_ctxt p in

  (* build global variable context *)
  let c = cmp_global_ctxt fc p in

  (* compile functions and global variables *)
  let fdecls, gdecls = 
    List.fold_right (fun d (fs, gs) ->
        match d with
        | Ast.Gvdecl { elt=gd } -> 
           let ll_gd, gs' = cmp_gexp c gd.init in
           (fs, (gd.name, ll_gd)::gs' @ gs)
        | Ast.Gfdecl fd ->
           let fdecl, gs' = cmp_fdecl c fd in
           (fd.elt.fname,fdecl)::fs, gs' @ gs
      ) p ([], [])
  in

  (* gather external declarations *)
  let edecls = internals @ builtins in
  { tdecls = []; gdecls; fdecls; edecls }
