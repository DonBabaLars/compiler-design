open Assert
open X86
open Driver
open Ll
open Backend

(* These tests are provided by you -- they will be graded manually *)

(* You should also add additional test cases here to help you   *)
(* debug your program.                                          *)

let subtype_tests = [
  "subtype_int_int",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TInt) (TInt) then ()
      else failwith "should not fail");
  "subtype_int_bool",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TInt) (TBool) then
        failwith "should not succeed" else ());
  "subtype_bool_bool",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TBool) (TBool) then ()
      else failwith "should not fail");
  "subtype_bool_int",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TBool) (TInt) then
        failwith "should not succeed" else ());
  "subtype_5",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TRef (RFun ([],RetVal TInt))) (TInt) then
        failwith "should not succeed" else ());
  "subtype_6",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TRef (RFun ([],RetVal TInt))) (TRef (RFun ([], RetVal TBool))) then
        failwith "should not succeed" else ());
  "subtype_7",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TRef (RFun ([],RetVal TInt))) (TRef (RFun ([], RetVal TInt))) then ()
      else failwith "should not fail");
  "subtype_8",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TRef (RFun ([TBool;TInt],RetVal TInt))) (TRef (RFun ([TBool;TInt], RetVal TInt))) then ()
      else failwith "should not fail");
  "subtype_9",
  (fun () ->
      if Typechecker.subtype Tctxt.empty (TRef (RFun ([TBool;TInt],RetVal TInt))) (TRef (RFun ([TBool], RetVal TInt))) then
        failwith "should not succeed" else ());
  "subtype_stringQ_stringQ",
   (fun () ->
       if Typechecker.subtype Tctxt.empty (TNullRef RString) (TNullRef RString) then ()
       else failwith "should not fail")                                                                                     
; ("no_subtype_stringQ_stringQ",
   (fun () ->
       if Typechecker.subtype Tctxt.empty (TNullRef RString) (TRef RString) then
         failwith "should not succeed" else ())
  )
]

let typecheck_tests = [

]

let provided_tests : suite = [
  GradedTest("Student subtype tests", 11, subtype_tests);
  GradedTest("Student typecheck tests", 0, typecheck_tests);
] 
