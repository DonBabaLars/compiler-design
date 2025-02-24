open Assert
open X86
open Simulator

(* You can use this file for additional test cases to help your *)
(* implementation.                                              *)

open Asm

let program_test (p:prog) (ans:int64) () =
  let res = assemble p |> load |> run in
  if res <> ans
  then failwith (Printf.sprintf("Expected %Ld but got %Ld") ans res)
  else ()

let sbyte_list (a: sbyte array) (start: int) : sbyte list =
  Array.to_list (Array.sub a start 8)

let stack_offset (i: quad) : operand = Ind3 (Lit i, Rsp)

let test_exec: exec =
  { entry = 0x400008L
  ; text_pos = 0x400000L
  ; data_pos = 0x400064L
  ; text_seg = [] 
  ; data_seg = []
  }

let test_machine (bs: sbyte list): mach =
  let mem = (Array.make mem_size (Byte '\x00')) in
  Array.blit (Array.of_list bs) 0 mem 0 (List.length bs);
  let regs = Array.make nregs 0L in
  regs.(rind Rip) <- mem_bot;
  regs.(rind Rsp) <- Int64.sub mem_top 8L;
  { flags = {fo = false; fs = false; fz = false};
    regs = regs;
    mem = mem
  }

let machine_test (s:string) (m: mach) (f:mach -> bool) () =
  (*for i=1 to n do step m done;*)
  let res = run m in
  if !debug_simulator then print_endline @@ ("Result: " ^ Int64.to_string res);
  if (f m) then () else failwith ("expected " ^ s ^ " but got " ^ Int64.to_string res)


let rec fact (n:int) = if n = 0 then 1 else n * fact (n-1)

let rec fib (n:int) = if n <= 1 then 1 else fib (n-1) + fib (n-2)


let factorial n = test_machine
[
  InsB0 (Pushq, [~$0xfdead]);InsFrag;InsFrag;InsFrag;InsFrag;InsFrag;InsFrag;InsFrag
  ;InsB0 (Movq, [~$n; ~%Rdi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Movq, [~$1; ~%Rbx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Movq, [~%Rdi; ~%Rcx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Cmpq, [~$1; ~%Rcx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (J Le, [~$0x400038]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Imulq, [~%Rcx; ~%Rbx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Decq, [~%Rcx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Cmpq, [~$1; ~%Rcx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (J Gt, [~$0x400020]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Movq, [~%Rbx; ~%Rax]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  ; InsB0 (Retq, []);InsFrag;InsFrag;InsFrag;InsFrag;InsFrag;InsFrag;InsFrag
]

let fibonacci n = test_machine
[
(*400000*) InsB0 (Pushq, [~$0xfdead]);InsFrag;InsFrag;InsFrag;InsFrag;InsFrag;InsFrag;InsFrag
(*400008*) ;InsB0 (Movq, [~$1; ~%Rbx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400010*) ;InsB0 (Movq, [~$1; ~%Rcx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400018*) ;InsB0 (Movq, [~$n; ~%Rdx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400020*) ;InsB0 (Cmpq, [~$1; ~%Rdx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400028*) ;InsB0 (J Le, [~$0x400060]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400030*) ;InsB0 (Movq, [~%Rcx; ~%Rax]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400038*) ;InsB0 (Addq, [~%Rbx; ~%Rcx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400040*) ;InsB0 (Movq, [~%Rax; ~%Rbx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400048*) ;InsB0 (Decq, [~%Rdx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400050*) ;InsB0 (Cmpq, [~$1; ~%Rdx]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400058*) ;InsB0 (J Gt, [~$0x400030]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400060*) ;InsB0 (Movq, [~%Rcx; ~%Rax]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400068*) ;InsB0 (Retq, []); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
]

let callTest n m = test_machine 
[
(*400000*) InsB0 (Pushq, [~$0xfdead]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400008*) ;InsB0 (Jmp, [~$0x400028]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag

(*400010*) ;InsB0 (Addq, [~%Rdi; ~%Rsi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400018*) ;InsB0 (Movq, [~%Rsi; ~%Rax]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400020*) ;InsB0 (Retq, []); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag

(*400028*) ;InsB0 (Movq, [~$n; ~%Rdi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400030*) ;InsB0 (Movq, [~$m; ~%Rsi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400038*) ;InsB0 (Callq, [~$0x400010]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
(*400040*) ;InsB0 (Retq, []); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
]

let gcd n m = test_machine
[
  
  (*400000*) InsB0 (Pushq, [~$0xfdead]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400008*) ;InsB0 (Jmp, [~$0x400058]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  

  (*400010*) ;InsB0 (Cmpq, [~%Rsi; ~%Rdi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400018*) ;InsB0 (J Eq, [~$0x400048]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400020*) ;InsB0 (J Le, [~$0x400038]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400028*) ;InsB0 (Subq, [~%Rsi; ~%Rdi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400030*) ;InsB0 (Jmp, [~$0x400010]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  

  (*400038*) ;InsB0 (Subq, [~%Rdi; ~%Rsi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400040*) ;InsB0 (Jmp, [~$0x400010]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  

  (*400048*) ;InsB0 (Movq, [~%Rdi; ~%Rax]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400050*) ;InsB0 (Retq, []); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  

  (*400058*) ;InsB0 (Movq, [~$n; ~%Rdi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400060*) ;InsB0 (Movq, [~$m; ~%Rsi]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400068*) ;InsB0 (Callq, [~$0x400010]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  (*400070*) ;InsB0 (Retq, []); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
  

]


 
let instruction_tests = [
      
  ("factorial", machine_test ("Rax= " ^ string_of_int (fact 8)) (factorial 8)
    (fun m -> m.regs.(rind Rax) = Int64.of_int (fact 8))
  ); 

  ("fibonacci", machine_test ("Rax= " ^ string_of_int (fib 7)) (fibonacci 7)
    (fun m -> m.regs.(rind Rax) = Int64.of_int (fib 7))
  ); 

  ("callTest", machine_test ("Rax= " ^ string_of_int (3 + 5)) (callTest 3 5)
    (fun m -> m.regs.(rind Rax) = Int64.of_int (3 + 5))
  ); 

  ("gcd1", machine_test ("Rax= " ^ string_of_int (6)) (gcd 18 12)
    (fun m -> m.regs.(rind Rax) = Int64.of_int (6))
  ); 

  ("gcd2", machine_test ("Rax= " ^ string_of_int (1)) (gcd 23 19)
  (fun m -> m.regs.(rind Rax) = Int64.of_int (1))
);
]


let provided_tests : suite = [
  (*Test("Instruction Tests", instruction_tests);*)
  Test("Sp20 tests", Sp20_tests.tests);
  Test("Sp18 tests", Sp18_tests.tests);
  Test("Sp17 tests", Sp17_tests.tests);
  Test("Sp15 tests", Sp15_tests.tests);
  Test("add_tests", Add_test.add_tests);
  Test("sub_tests", Sub_test.sub_tests);
  Test("xor_tests", Xor_test.xor_tests);
  Test("shift_tests", Shift_test.shift_tests);
  (*Test("invall_tests", Invalid_test.invalid_tests);*)
  Test("kek", Kek.kek_tests);
  (*Test("apoth_tests", Sp17_tests.apoth_tests);*)
  (*Test("Sp20 tests", Sp20_tests.nshweky_tests);*)
  
]
