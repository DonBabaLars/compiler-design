(* X86lite Simulator *)

(* See the documentation in the X86lite specification, available on the 
   course web pages, for a detailed explanation of the instruction
   semantics.
*)

(* Test 6*)
open X86



(* simulator machine state -------------------------------------------------- *)

let mem_bot = 0x400000L          (* lowest valid address *)
let mem_top = 0x410000L          (* one past the last byte in memory *)
let mem_size = Int64.to_int (Int64.sub mem_top mem_bot)
let nregs = 17                   (* including Rip *)
let ins_size = 8L                (* assume we have a 8-byte encoding *)
let exit_addr = 0xfdeadL         (* halt when m.regs(%rip) = exit_addr *)

(* Your simulator should raise this exception if it tries to read from or
   store to an address not within the valid address space. *)
exception X86lite_segfault

(* The simulator memory maps addresses to symbolic bytes.  Symbolic
   bytes are either actual data indicated by the Byte constructor or
   'symbolic instructions' that take up eight bytes for the purposes of
   layout.

   The symbolic bytes abstract away from the details of how
   instructions are represented in memory.  Each instruction takes
   exactly eight consecutive bytes, where the first byte InsB0 stores
   the actual instruction, and the next seven bytes are InsFrag
   elements, which aren't valid data.

   For example, the two-instruction sequence:
        at&t syntax             ocaml syntax
      movq %rdi, (%rsp)       Movq,  [~%Rdi; Ind2 Rsp]
      decq %rdi               Decq,  [~%Rdi]

   is represented by the following elements of the mem array (starting
   at address 0x400000):

       0x400000 :  InsB0 (Movq,  [~%Rdi; Ind2 Rsp])
       0x400001 :  InsFrag
       0x400002 :  InsFrag
       0x400003 :  InsFrag
       0x400004 :  InsFrag
       0x400005 :  InsFrag
       0x400006 :  InsFrag
       0x400007 :  InsFrag
       0x400008 :  InsB0 (Decq,  [~%Rdi])
       0x40000A :  InsFrag
       0x40000B :  InsFrag
       0x40000C :  InsFrag
       0x40000D :  InsFrag
       0x40000E :  InsFrag
       0x40000F :  InsFrag
       0x400010 :  InsFrag
*)
type sbyte = InsB0 of ins       (* 1st byte of an instruction *)
           | InsFrag            (* 2nd - 8th bytes of an instruction *)
           | Byte of char       (* non-instruction byte *)

(* memory maps addresses to symbolic bytes *)
type mem = sbyte array

(* Flags for condition codes *)
type flags = { mutable fo : bool
             ; mutable fs : bool
             ; mutable fz : bool
             }

(* Register files *)
type regs = int64 array

(* Complete machine state *)
type mach = { flags : flags
            ; regs : regs
            ; mem : mem
            }

(* simulator helper functions ----------------------------------------------- *)

(* The index of a register in the regs array *)
let rind : reg -> int = function
  | Rip -> 16
  | Rax -> 0  | Rbx -> 1  | Rcx -> 2  | Rdx -> 3
  | Rsi -> 4  | Rdi -> 5  | Rbp -> 6  | Rsp -> 7
  | R08 -> 8  | R09 -> 9  | R10 -> 10 | R11 -> 11
  | R12 -> 12 | R13 -> 13 | R14 -> 14 | R15 -> 15

(* Helper functions for reading/writing sbytes *)

(* Convert an int64 to its sbyte representation *)
let sbytes_of_int64 (i:int64) : sbyte list =
  let open Char in 
  let open Int64 in
  List.map (fun n -> Byte (shift_right i n |> logand 0xffL |> to_int |> chr))
           [0; 8; 16; 24; 32; 40; 48; 56]

(* Convert an sbyte representation to an int64 *)
let int64_of_sbytes (bs:sbyte list) : int64 =
  let open Char in
  let open Int64 in
  let f b i = match b with
    | Byte c -> logor (shift_left i 8) (c |> code |> of_int)
    | _ -> 0L
  in
  List.fold_right f bs 0L

(* Convert a string to its sbyte representation *)
let sbytes_of_string (s:string) : sbyte list =
  let rec loop acc = function
    | i when i < 0 -> acc
    | i -> loop (Byte s.[i]::acc) (pred i)
  in
  loop [Byte '\x00'] @@ String.length s - 1

(* Serialize an instruction to sbytes *)
let sbytes_of_ins (op, args:ins) : sbyte list =
  let check = function
    | Imm (Lbl _) | Ind1 (Lbl _) | Ind3 (Lbl _, _) -> 
      invalid_arg "sbytes_of_ins: tried to serialize a label!"
    | o -> ()
  in
  List.iter check args;
  [InsB0 (op, args); InsFrag; InsFrag; InsFrag;
   InsFrag; InsFrag; InsFrag; InsFrag]

(* Serialize a data element to sbytes *)
let sbytes_of_data : data -> sbyte list = function
  | Quad (Lit i) -> sbytes_of_int64 i
  | Asciz s -> sbytes_of_string s
  | Quad (Lbl _) -> invalid_arg "sbytes_of_data: tried to serialize a label!"


(* It might be useful to toggle printing of intermediate states of your 
   simulator. Our implementation uses this mutable flag to turn on/off
   printing.  For instance, you might write something like:

     [if !debug_simulator then print_endline @@ string_of_ins u; ...]

*)
let debug_simulator = ref false

(* Interpret a condition code with respect to the given flags. *)
let interp_cnd {fo; fs; fz} : cnd -> bool = fun x ->
  match x with (* Select Condition from Eq | Neq | Gt | Ge | Lt | Le *)
    | Eq  -> if (fz) then true else false
    | Neq -> if (not fz) then true else false
    | Lt  -> if (not (fs = fo)) then true else false
    | Le  -> if ((not (fs = fo))||fz) then true else false
    | Gt  -> if (not ((not (fs = fo))||fz)) then true else false (* Code replication for preformance *)
    | Ge  -> if (fs = fo) then true else false
    (* | _ -> false ERROR: Invalid condition code *)

(* Maps an X86lite address into Some OCaml array index, 
   or None if the address is not within the legal address space. *)
let map_addr (addr:quad) : int option =
  if (mem_bot <= addr && addr < mem_top ) then
    Some (Int64.to_int (Int64.sub addr mem_bot))
  else
    None



(* HELPERS FOR WRITING AND READING  --------------------------------------------------------------------------*)

(* Inserts 8 sbytes into memory *)
let insert_sbytes (mem:mem) (sbyteList:sbyte list) (adress:int) : unit =
  Array.blit (Array.of_list sbyteList) 0 mem adress 8


(* Reads 8 sbytes from memory*)
let read_sbytes (m:mach) (adress:int) : sbyte list =
  [m.mem.(adress);m.mem.(adress+1);m.mem.(adress+2);m.mem.(adress+3);m.mem.(adress+4);m.mem.(adress+5);m.mem.(adress+6);m.mem.(adress+7)]


(* interpretation of operands *)
let read_op_value (m:mach) (op:operand) : int64 =
  let regs = m.regs in

  match op with
    | Imm imm ->
      (match imm with
        | Lit quad -> quad
        | Lbl lbl  -> failwith "Trying to resolve operand: Immediate of type Label")

    | Reg reg -> regs.(rind reg) 

    | Ind1 imm -> (match imm with
      | Lit quad -> (match map_addr quad with                            (* Converts address to OCaml array index for mem array *)
        | Some addr -> int64_of_sbytes (read_sbytes m addr)                     (* if valid get content *)
        | None -> raise X86lite_segfault)                               (* otherwise segfault *)
      | Lbl lbl  -> failwith "Trying to resolve operand: Ind1 of type Label")

    | Ind2 reg -> (
      let addr_from_reg = regs.(rind reg) in             (* Get adress from register *)
      match map_addr addr_from_reg with                (* Converts address to OCaml array index for mem array *)
        | Some addr -> int64_of_sbytes (read_sbytes m addr)        (* if valid get content *)
        | None -> raise X86lite_segfault)                (* otherwise segfault *)

    | Ind3 (imm, reg) -> 
      (match imm, Reg reg with
        | Lit quad, _ -> ( (* Case: Immediate is Quad *)
          let addr_from_reg = regs.(rind reg) in              (* Get adress from register *)
          let addr_adjusted = Int64.add addr_from_reg quad in (* Add immediate to that adress *)
          match map_addr addr_adjusted with                   (* Convert address to OCaml array index for mem array *)
            | Some addr -> int64_of_sbytes (read_sbytes m addr)         (* if valid get content (converted from sbytes to int64) *)
            | None -> raise X86lite_segfault)                   (* otherwise segfault *)

        | Lbl lbl, _ -> failwith "Trying to resolve operand: Ind3 of type Label"               
      )

(* Write to an operand *)
let write_op_value (m:mach) (op:operand) (v:int64): unit =
  let regs = m.regs in

  match op with
    | Imm imm -> failwith "Trying to store to operand: Immediate"

    | Reg reg -> regs.(rind reg) <- v

    | Ind1 imm -> (match imm with
      | Lit quad -> (match map_addr quad with                            (* Converts address to OCaml array index for mem array *)
        | Some addr -> insert_sbytes m.mem (sbytes_of_int64 v) addr                 (* if valid get content *)
        | None -> raise X86lite_segfault)                               (* otherwise segfault *)
      | Lbl lbl  -> failwith "Trying to resolve operand: Ind1 of type Label")

    | Ind2 reg -> (
      let addr_from_reg = regs.(rind reg) in             (* Get adress from register *)
      match map_addr addr_from_reg with                (* Converts address to OCaml array index for mem array *)
        | Some addr -> insert_sbytes m.mem (sbytes_of_int64 v) addr        (* if valid get content *)
        | None -> raise X86lite_segfault)                (* otherwise segfault *)

    | Ind3 (imm, reg) ->
      (match imm, Reg reg with
        | Lit quad, _ -> ( (* Case: Immediate is Quad *)
          let addr_from_reg = regs.(rind reg) in              (* Get adress from register *)
          let addr_adjusted = Int64.add addr_from_reg quad in (* Add immediate to that adress *)
          match map_addr addr_adjusted with                   (* Convert address to OCaml array index for mem array *)
            | Some addr -> insert_sbytes m.mem (sbytes_of_int64 v) addr       (*if valid get content (converted from sbyte to int64) *)
            | None -> raise X86lite_segfault)                   (* otherwise segfault *)

        | Lbl lbl, _ -> failwith "Trying to resolve operand: Ind3 of type Label"               
      )
  




(* HELPERS FOR STEP ---------------------------------------------------------------------------*)


(* Updates Rip to next instruction *)
let update_rip (m: mach) (amt:int64) : unit =
  let rip_index = rind Rip in
  m.regs.(rip_index) <- Int64.add m.regs.(rip_index) amt  (* Increment Rip by 8 bytes *)

(* Sets Rip to value *)
let set_rip (m:mach) (quad:int64) : unit =
  m.regs.(rind Rip) <- quad

(* Updates Rsp to next instruction *)
let update_rsp (m: mach) (amt:int64) : unit =
  let rsp_index = rind Rsp in
  m.regs.(rsp_index) <- Int64.add m.regs.(rsp_index) amt  (* Increment Rip by 8 bytes *) 

(* Helper to get instruction *)
let sbyte_to_ins (s: sbyte) : ins option =
  match s with
  | InsB0 instr -> Some instr
  | _ -> None

(* Helper that fetches instruction at %rip *)
let fetch (m:mach) : ins =
  match map_addr m.regs.(rind Rip) with
  | None -> raise X86lite_segfault
  | Some addr ->
    match sbyte_to_ins m.mem.(addr) with
    | Some ins -> ins
    | None -> raise X86lite_segfault

(* Helper that sets flags *)
let update_flags_arith flags (res:Int64_overflow.t) : unit =
  flags.fo <- res.overflow; (* Update overflow flag *)
  flags.fs <- Int64.compare res.value Int64.zero < 0; (* Update sign flag: set if result is negative *)
  flags.fz <- Int64.compare res.value Int64.zero = 0 (* Update zero flag: set if result is zero *)

(* Helper that sets flags *)
let update_flags flags (res:int64) : unit =
  flags.fo <- false; (*Update overflow flag*)
  flags.fs <- Int64.compare res Int64.zero < 0; (* Update sign flag: set if result is negative *)
  flags.fz <- Int64.compare res Int64.zero = 0 (* Update zero flag: set if result is zero *)




(* HELPERS FOR INSTRUCTIONS ---------------------------------------------------------------------------*)

(* Helper(s) for Arithmetic expressions *)
let unary_arithmetic_helper (m:mach) (op1:operand) f : unit =
  let a = read_op_value m op1 in
  let res = f a in
  update_flags_arith m.flags res;
  write_op_value m op1 res.value;
  update_rip m 8L

let binary_arithmetic_helper (m:mach) (op1:operand) (op2:operand) f (is_subtract:bool) (can_write:bool) : unit =
  let a = read_op_value m op1 in
  let b = read_op_value m op2 in
  let res =  if (is_subtract) then (f b a) else (f a b) in
  update_flags_arith m.flags res;
  if (a = -9223372036854775808L && is_subtract) then (m.flags.fo <- true); (* Special case for overflow *)
  if can_write then (write_op_value m op2 res.value) else ();
  update_rip m 8L
  

(* Helper for Logic Instructions *)
let logic_helper (m:mach) (op1:operand) (op2:operand) (ins:opcode) : unit =
  let a = read_op_value m op1 in
  let b = read_op_value m op2 in
  let res = match ins with
    | Notq -> Int64.lognot a
    | Xorq -> Int64.logxor a b
    | Orq  -> Int64.logor  a b
    | Andq -> Int64.logand a b
    | _ -> failwith "Invalid logic instruction" in
  write_op_value m op2 res;
  update_flags m.flags res;
  update_rip m 8L
    
(* Helper for Bit-manipulation Instructions *)
let bit_manip_helper (m:mach) (amt:operand) (dest:operand) (ins:opcode) : unit =
  let a = read_op_value m dest in
  let shift_amt = Int64.to_int (read_op_value m amt) in
  if shift_amt <> 0 then (
    let res = match ins with
      | Sarq -> (let res = (Int64.shift_right a shift_amt) in 
          m.flags.fo <- if (shift_amt = 1) then false else m.flags.fo;
          m.flags.fs <- Int64.(res < 0L);
          m.flags.fz <- Int64.(res = 0L); res)
      | Shlq -> (let res =  Int64.shift_left a shift_amt in
        let a63 = Int64.(to_int (shift_right_logical a 63) land 1) in
        let a62 = Int64.(to_int (shift_right_logical a 62) land 1) in
          m.flags.fo <- if (shift_amt = 1) then (if (a63 = a62) then false else true) else m.flags.fo;
          m.flags.fs <- Int64.(res < 0L);
          m.flags.fz <- Int64.(res = 0L); res)
      | Shrq -> (let res =  Int64.shift_right_logical a shift_amt in
        let a63 = Int64.(to_int (shift_right_logical a 63) land 1) in
        let res63 = Int64.(to_int (shift_right_logical res 63) land 1) in
          m.flags.fo <- if (shift_amt = 1) then (a63 = 1) else m.flags.fo;
          m.flags.fs <- (res63 = 1);
          m.flags.fz <- Int64.(res = 0L); res)
      | _ -> failwith "Invalid bit manipulation instruction" in
    
    write_op_value m dest res
  );
    update_rip m 8L


(* Helper for Data-movement Instructions *)
let data_mov_helper (m:mach) (op1:operand) (op2:operand) (ins:opcode) : unit =
  match ins with
    | Pushq -> 
      let a = read_op_value m op1 in
      update_rsp m (-8L);
      write_op_value m (Ind2 Rsp) a;
      update_rip m 8L
    | Popq ->
      write_op_value m op1 (read_op_value m (Ind2 Rsp));
      update_rsp m (8L);
      update_rip m 8L
    | Movq ->
      let a = read_op_value m op1 in
      write_op_value m op2 a;
      update_rip m 8L;
    | Leaq ->
      let addr = match op1 with
        | Ind1 x -> read_op_value m (Imm x)
        | Ind2 x -> read_op_value m (Reg x)
        | Ind3 (x,y) -> Int64.add (read_op_value m (Imm x)) (read_op_value m (Reg y))
        | _ -> failwith "Invalid operand for leaq" in
      write_op_value m op2 addr;
      update_rip m 8L
    | _ -> failwith "Invalid binary data movement instruction"

    

(* Helpers for Control-flow and condition Instructions *)
let handle_jump (m:mach) (target:operand) : unit =
  let target_address = read_op_value m target in
  set_rip m target_address

let handle_general_jump (m:mach) (cnd:cnd) (target:operand) : unit =
  if (interp_cnd m.flags cnd) then handle_jump m target else update_rip m 8L

let handle_cmpq (m:mach) (op1:operand) (op2:operand) : unit =
  binary_arithmetic_helper m op1 op2 Int64_overflow.sub true  false (* Does subtraction and sets flags without writing *)

let handle_callq (m:mach) (target:operand) : unit =
  let return_address = Int64.add m.regs.(rind Rip) 8L in
  update_rsp m (-8L);
  write_op_value m (Ind2 Rsp) return_address;
  handle_jump m target

let handle_retq (m:mach) : unit =
  let return_address = read_op_value m (Ind2 Rsp) in
  update_rsp m (8L);
  set_rip m return_address

let set_cnd_helper (m:mach) (cnd:cnd) (dest:operand) : unit = (* CAUTION: This overwrites all 8 bytes not only the lower byte *)
  let res = if (interp_cnd m.flags cnd) then 1L else 0L in
  write_op_value m dest res;
  update_rip m 8L
  

(* simulation loop ---------------------------------------------------------- *)

(* Simulates one step of the machine:
    - fetch the instruction at %rip
    - compute the source and/or destination information from the operands
    - simulate the instruction semantics
    - update the registers and/or memory appropriately
    - set the condition flags
*)
let step (m:mach) : unit =
  let fetched_ins = fetch m in
  if !debug_simulator then print_endline @@ string_of_ins fetched_ins;
  (match fetched_ins with
    (* Arithmetic Instructions *)
    | (Negq,  [dest])       -> unary_arithmetic_helper  m dest           Int64_overflow.neg
    | (Addq,  [src; dest])  -> binary_arithmetic_helper m src dest       Int64_overflow.add false true
    | (Subq,  [src; dest])  -> binary_arithmetic_helper m src dest       Int64_overflow.sub true  true
    | (Imulq, [src; reg])   -> binary_arithmetic_helper m src reg        Int64_overflow.mul false true
    | (Incq,  [src])        -> unary_arithmetic_helper  m src            Int64_overflow.succ
    | (Decq,  [src])        -> unary_arithmetic_helper  m src            Int64_overflow.pred

    (* Logic Instructions *)
    | (Notq,  [dest])      -> logic_helper m dest dest Notq (* Note that we just pass dest twice to avoid having to differentiate on the amount of ops *)
    | (Xorq,  [src; dest]) -> logic_helper m src dest Xorq
    | (Orq,   [src; dest]) -> logic_helper m src dest Orq
    | (Andq,  [src; dest]) -> logic_helper m src dest Andq

    (* Bit-manipulation Instructions *)
    | (Shlq,  [amt; dest]) -> bit_manip_helper m amt dest Shlq
    | (Sarq,  [amt; dest]) -> bit_manip_helper m amt dest Sarq
    | (Shrq,  [amt; dest]) -> bit_manip_helper m amt dest Shrq
    | (Set cnd, [dest])     -> set_cnd_helper m cnd dest

    (* Data-movement Instructions *)
    | (Movq,  [src; dest])  -> data_mov_helper m src  dest Movq
    | (Pushq, [src])        -> data_mov_helper m src  src  Pushq (* Note that we just pass dest twice to avoid having to differentiate on the amount of ops *)
    | (Popq,  [dest])       -> data_mov_helper m dest dest Popq (* Note that we just pass dest twice to avoid having to differentiate on the amount of ops *)
    | (Leaq,  [ind; dest])  -> data_mov_helper m ind  dest Leaq

    (* Control-flow and condition Instructions *)
    | (Jmp,   [src])        -> handle_jump m src
    | (J cnd, [src])        -> handle_general_jump m cnd src
    | (Cmpq,  [src1; src2]) -> handle_cmpq m src1 src2
    | (Callq, [src])        -> handle_callq m src
    | (Retq,  [])           -> handle_retq m
    
    (* Somethig went wrong... *)
    | _ -> failwith "Instruction not supported"
  )

  (* Handled inside instruction-helpers:
      - Updating Registers/Memory
      - Setting Flags
      - Updating RIP as necessary
  *)

(* Runs the machine until the rip register reaches a designated
   memory address. Returns the contents of %rax when the 
   machine halts. *)
let run (m:mach) : int64 = 
  while m.regs.(rind Rip) <> exit_addr do step m done;
  m.regs.(rind Rax)





(* assembling and linking --------------------------------------------------- *)

(* A representation of the executable *)
type exec = { entry    : quad              (* address of the entry point *)
            ; text_pos : quad              (* starting address of the code *)
            ; data_pos : quad              (* starting address of the data *)
            ; text_seg : sbyte list        (* contents of the text segment *)
            ; data_seg : sbyte list        (* contents of the data segment *)
            }

(* Assemble should raise this when a label is used but not defined *)
exception Undefined_sym of lbl

(* Assemble should raise this when a label is defined more than once *)
exception Redefined_sym of lbl

(* Write a datastructure for a symbol table*)

(* Helper function to add a label to the symbol table*)
let add_label_to_symtab symtab (lbl:lbl) (quad:quad) : unit =
  if (Hashtbl.mem symtab lbl) then raise (Redefined_sym lbl) else Hashtbl.add symtab lbl quad
(* Helper function to get a label from the symbol table*)
let get_label_from_symtab symtab (lbl:lbl) : quad =
  if (Hashtbl.mem symtab lbl) then Hashtbl.find symtab lbl else raise (Undefined_sym lbl)

(* Helper function that empties Hastable for next iteration*)
let clear_symtab symtab () : unit =
  Hashtbl.reset symtab

(* print all the content of the hashtabl*)
let get_symtab symtab () : unit =
  print_endline "Hastable:";
  Hashtbl.iter (fun key value -> print_endline (key ^ ": " ^ Int64.to_string value)) symtab

(* Recursive helper that takes a list of data elements and returns a list of labels in them *)

(* Recursive helper that takes an elem e and returns the size of it in bytes *)

let get_data_length (dataL : data list) : int64 =
  let rec loop (dataL : data list) (len:int64) : int64 =
    match dataL with
      | [] -> len
      | (data :: data_list) -> (
        match data with
          | Quad (Lit i) -> loop data_list (Int64.add len 8L)
          | Asciz s -> loop data_list (Int64.add len (Int64.of_int ((String.length s)+1)))
          | Quad (Lbl _) -> loop data_list (Int64.add len 8L)
      ) in
  loop dataL 0L

let handle_elem1 symtab (e:elem) (addr:quad) : int64 = 
  let {lbl; global; asm} = e in
  let asm_size = match asm with
    | Text x -> Int64.of_int ((List.length x) * 8) 
    | Data x -> get_data_length x in
  add_label_to_symtab symtab lbl addr;
  asm_size


(* Recursive helper that takes a prog p and returns a list of labels in them *)
let handle_prog1 symtab (p:prog) (addr:quad): unit =
  let rec loop symtab (p:prog) (addr:quad): int64 =
    match p with
      | [] -> addr
      | (e :: ps) -> 
        let new_addr = Int64.add addr (handle_elem1 symtab e addr) in
          (loop symtab ps new_addr) in
  ignore (loop symtab p addr) (* This makes it so that the return value of loop is discarded and thus fits the value unit we want*)

(* Recursively goes over the instruction List and switches labels with the corresponding value from the hashtable*)
let rec handle_ins2 symtab (instructions : ins list) : sbyte list =
  match instructions with
    | [] -> []
    | ((op, []) :: ins_list) -> (sbytes_of_ins (op, [])) @ (handle_ins2 symtab ins_list)
    | ((op, [x]) :: ins_list) -> 
      let new_x = match x with
        | Imm Lbl a -> (Imm (Lit (get_label_from_symtab symtab a)))
        | Ind1 Lbl a -> (Ind1 (Lit (get_label_from_symtab symtab a)))
        | Ind3 (Lbl a,b) -> (Ind3 ((Lit (get_label_from_symtab symtab a)),b))
        | _ -> x in
          (sbytes_of_ins (op, [new_x])) @ (handle_ins2 symtab ins_list)
    | ((op, [x; y]) :: ins_list) -> 
      let new_x = match x with
        | Imm Lbl a1 -> (Imm (Lit (get_label_from_symtab symtab a1)))
        | Ind1 Lbl a1 -> (Ind1 (Lit (get_label_from_symtab symtab a1)))
        | Ind3 (Lbl a1,b1) -> (Ind3 (Lit (get_label_from_symtab symtab a1),b1))
        | _ -> x in
          let new_y = match y with
            | Imm Lbl a2 -> (Imm (Lit (get_label_from_symtab symtab a2)))
            | Ind1 Lbl a2 -> (Ind1 (Lit (get_label_from_symtab symtab a2)))
            | Ind3 (Lbl a2,b2) -> (Ind3 (Lit (get_label_from_symtab symtab a2),b2))
            | _ -> y in
              (sbytes_of_ins (op, [new_x; new_y])) @ (handle_ins2 symtab ins_list)
        
    | _ -> failwith "Invalid amount of ops in instruction"



let rec handle_data2 symtab (dataL : data list) : sbyte list =
  match dataL with
    | [] -> []
    | (data :: data_list) -> sbytes_of_data data @ handle_data2 symtab data_list

(* Recursive helper that takes an elem e and returns a list of instructions in them *)


let handle_elem2 symtab (e:elem) : (sbyte list * sbyte list) = 
  let {lbl; global; asm} = e in
  match asm with
    | Text x -> (handle_ins2 symtab x, [])
    | Data x -> ([], handle_data2 symtab x)

(* Helper that takes two pairs of two sbyte lists and appends the the first two and the second two into a new pair*)
let append_pair (pair1: (sbyte list * sbyte list)) (pair2: (sbyte list * sbyte list)) : (sbyte list * sbyte list) =
  let (a1, b1) = pair1 in
  let (a2, b2) = pair2 in
  match (a1, b1, a2, b2) with
    | (a1, [], [], []) -> (a1, [])
    | (a1, [], a2, []) -> (a1 @ a2, [])
    | (a1, [], [], b2) -> (a1, b2)
    | (a1, [], a2, b2) -> (a1 @ a2, b2)
    | ([], b1, [], []) -> ([], b1)
    | ([], b1, a2, []) -> (a2, b1)
    | ([], b1, [], b2) -> ([], b1 @ b2)
    | ([], b1, a2, b2) -> (a2, b1 @ b2)
    | (a1, b1, [], []) -> (a1, b1)
    | (a1, b1, [], b2) -> (a1, b1 @ b2)
    | (a1, b1, a2, []) -> (a1 @ a2, b1)
    | _ -> failwith "Invalid append_pair input"
  
(* Recursive helper that takes a prog p and returns a list of labels in them *)
let rec handle_prog2 symtab (p:prog) : (sbyte list * sbyte list) =
  match p with
    | [] -> ([],[])
    | (e::ps) -> 
      append_pair (handle_elem2 symtab e) (handle_prog2 symtab ps)


(* Recursive helper that takes a single prog and pushes all the data segments to the end of the prog so that first we have all text and then all data in a single program *)
let rec handle_prog0 (p:prog) (data_seg:elem list) : prog =
  match p with
    | [] -> p @ data_seg
    | (e::ps) -> 
      let {lbl; global; asm} = e in
      match asm with
        | Text x -> e :: handle_prog0 ps data_seg
        | Data x -> handle_prog0 ps (data_seg @ [e])





(* Convert an X86 program into an object file:
   - separate the text and data segments
   - compute the size of each segment
      Note: the size of an Asciz string section is (1 + the string length)
            due to the null terminator

   - resolve the labels to concrete addresses and 'patch' the instructions to 
     replace Lbl values with the corresponding Imm values.

   - the text segment starts at the lowest address
   - the data segment starts after the text segment

  HINT: List.fold_left and List.fold_right are your friends.
 *)
let assemble (p0:prog) : exec =
  let p = handle_prog0 p0 [] in
  let symbtab = Hashtbl.create 100 in
  handle_prog1 symbtab p 0x400000L;
  (*get_symtab symbtab ();*)
  let (assembled, data) = (handle_prog2 symbtab p) in
  let data_start_pos = Int64.add 0x400000L (Int64.of_int (List.length assembled)) in
  let entry_val = get_label_from_symtab symbtab "main" in
  let exec = { entry = entry_val; text_pos = 0x400000L; data_pos = data_start_pos; text_seg = assembled; data_seg = data } in  
  exec



(* 1. Calculate addresses: Text is 0x400000, Data is basically 0x400000 + amount_of_insts + 1 *)
(* 2. Traverse code once and build up a symbol table that stores an address for each label*)
(* 3. Convert instructions to sbytes and translate labels in them to actuall adresses from symbol table*)



(* Convert an object file into an executable machine state. 
    - allocate the mem array
    - set up the memory state by writing the symbolic bytes to the 
      appropriate locations 
    - create the inital register state
      - initialize rip to the entry point address
      - initializes rsp to the last word in memory 
      - the other registers are initialized to 0
    - the condition code flags start as 'false'

  Hint: The Array.make, Array.blit, and Array.of_list library functions 
  may be of use.
*)
let load {entry; text_pos; data_pos; text_seg; data_seg} : mach = 
  let mem = Array.make mem_size (Byte '\x00') in
  let text_seg_array = Array.of_list text_seg in
  let data_seg_array = Array.of_list data_seg in
  Array.blit text_seg_array 0 mem 0 (List.length text_seg);
  Array.blit data_seg_array 0 mem (List.length text_seg) (List.length data_seg);
  let regs = Array.make 17 0L in
  regs.(rind Rip) <- entry;
  regs.(rind Rsp) <- Int64.sub mem_top 8L;
  (* This can be done better: *)
  insert_sbytes mem (sbytes_of_int64 exit_addr) (match (map_addr (Int64.sub mem_top 8L)) with
    | Some addr -> addr
    | None -> raise X86lite_segfault);
  { flags = {fo = false; fs = false; fz = false}
  ; regs
  ; mem
  }




  (* CHECKLISTE:
      - PROBLEM: Data is stored with padding... should be without... (FIXED)
      - Reverse changes to Segfault exceptions (DONE)
      - Check if int64_overflow can be importet (DONE)
      - Clean up all print_endline statements (DONE)
      - First pass could be avoided (But works)

      - Check if works on new docker file
    
  *)