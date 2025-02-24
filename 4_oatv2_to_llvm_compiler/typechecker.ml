open Ast
open Astlib
open Tctxt

(* Error Reporting ---------------------------------------------------------- *)
(* NOTE: Use type_error to report error messages for ill-typed programs. *)

exception TypeError of string

let type_error (l : 'a node) err =
  let (_, (s, e), _) = l.loc in
  raise (TypeError (Printf.sprintf "[%d, %d] %s" s e err))


(* initial context: G0 ------------------------------------------------------ *)
(* The Oat types of the Oat built-in functions *)
let builtins =
  [ "array_of_string",  ([TRef RString],  RetVal (TRef(RArray TInt)))
  ; "string_of_array",  ([TRef(RArray TInt)], RetVal (TRef RString))
  ; "length_of_string", ([TRef RString],  RetVal TInt)
  ; "string_of_int",    ([TInt], RetVal (TRef RString))
  ; "string_cat",       ([TRef RString; TRef RString], RetVal (TRef RString))
  ; "print_string",     ([TRef RString],  RetVoid)
  ; "print_int",        ([TInt], RetVoid)
  ; "print_bool",       ([TBool], RetVoid)
  ]

(* binary operation types --------------------------------------------------- *)
let typ_of_binop : Ast.binop -> Ast.ty * Ast.ty * Ast.ty = function
  | Add | Mul | Sub | Shl | Shr | Sar | IAnd | IOr -> (TInt, TInt, TInt)
  | Lt | Lte | Gt | Gte -> (TInt, TInt, TBool)
  | And | Or -> (TBool, TBool, TBool)
  | Eq | Neq -> failwith "typ_of_binop called on polymorphic == or !="

(* unary operation types ---------------------------------------------------- *)
let typ_of_unop : Ast.unop -> Ast.ty * Ast.ty = function
  | Neg | Bitnot -> (TInt, TInt)
  | Lognot       -> (TBool, TBool)

let dummynode = no_loc (CInt 0L)

(* printing tctxt Diego --------------------------*)
let print_ctxt (c: Tctxt.t) : unit =
  (* Function to print a list of (id, ty) tuples *)
  let print_id_ty_list list =
    List.iter (fun (id, ty) -> Printf.printf "(%s, %s)\n" id (string_of_ty ty)) list in

  (* Function to print a list of (id, field list) tuples *)
  let print_struct_list list =
    List.iter (fun (id, fields) ->
      Printf.printf "%s: [\n" id;
      List.iter (fun field -> Printf.printf " {fieldName = %s; ftyp = %s}\n" field.fieldName (string_of_ty field.ftyp)) fields;
      Printf.printf "]\n"
    ) list in

  (Printf.printf "---- Context (Tctxt): -----------------------------\n";

  Printf.printf "Local Context:\n";
  print_id_ty_list c.locals;

  Printf.printf "\nGlobal Context:\n";
  print_id_ty_list c.globals;

  Printf.printf "\nStruct Context:\n";
  print_struct_list c.structs;

  Printf.printf "\n------------------------------------------------------\n";)


(* subtyping ---------------------------------------------------------------- *)
(* Decides whether H |- t1 <: t2
    - assumes that H contains the declarations of all the possible struct types

    - you will want to introduce addition (possibly mutually recursive)
      helper functions to implement the different judgments of the subtyping
      relation. We have included a template for subtype_ref to get you started.
      (Don't forget about OCaml's 'and' keyword.)
*)
let rec subtype (c : Tctxt.t) (t1 : Ast.ty) (t2 : Ast.ty) : bool =
  match t1 with
    | TInt ->  (t2 = TInt)                                (* SUB_SUB_INT *)
    | TBool -> (t2 = TBool)                              (* SUB_SUB_BOOL *)
    | TRef rt1 -> (match t2 with
        | TRef rt2 -> subtype_ref c rt1 rt2               (* SUB_SUB_REF *)
        | TNullRef rt2 -> subtype_ref c rt1 rt2           (* SUB_SUB_NRREF *)
        | _ -> false)
    | TNullRef rt1->
      (match t2 with
        | TNullRef rt2 -> subtype_ref c rt1 rt2           (* SUB_SUB_NREF *)
        | _ -> false)
(* Decides whether H |-r ref1 <: ref2 *)
and subtype_ref (c : Tctxt.t) (rt1 : Ast.rty) (rt2 : Ast.rty) : bool =
  match (rt1,rt2) with
    | (RString, RString) -> true                                        (* SUB_SUBRSTRING *)
    | (RArray t1, RArray t2) -> (t1 = t2)                              (* SUB_SUBRARRAY *)
    | (RStruct id1, RStruct id2) ->                                    (* SUB_SUBRSTRUCT *)
      (match (Tctxt.lookup_struct_option id1 c, Tctxt.lookup_struct_option id2 c) with
        | (Some fs1, Some fs2) ->
          let rec typesCheck (fs1 : Ast.field list) (fs2 : Ast.field list) : bool =
            match (fs1, fs2) with
              | (_, []) -> true
              | (h1 :: t1, h2 :: t2) -> (h1.fieldName = h2.fieldName) && (h1.ftyp = h2.ftyp) && (typesCheck t1 t2)
              | _ -> false
          in
          typesCheck fs1 fs2
        | _ -> false)
    | (RFun (tls1, rett1), RFun (tls2, rett2)) ->                      (* SUB_SUBRFUNT *)
        if (List.length tls1) != (List.length tls2) then false else
        let paired = List.combine tls1 tls2 in
        let paired_bool = List.map (fun (t1, t2) -> subtype c t2 t1) paired in
        let copmare_ret = subtype_ret c rett1 rett2 in
        List.fold_right (fun b acc -> b && acc) paired_bool true && copmare_ret
    | _ -> false

and subtype_ret (c : Tctxt.t) (rett1 : Ast.ret_ty) (rett2 : Ast.ret_ty) : bool =
  match (rett1, rett2) with
    | (RetVoid, RetVoid) -> true                          (* SUB_SUBRTYVOID *)
    | (RetVal t1, RetVal t2) -> subtype c t1 t2           (* SUB_SUBRTYRET *)
    | _ -> false


(* well-formed types -------------------------------------------------------- *)
(* Implement a (set of) functions that check that types are well formed according
   to the H |- t and related inference rules

    - the function should succeed by returning () if the type is well-formed
      according to the rules

    - the function should fail using the "type_error" helper function if the
      type is not well-formed

    - l is just an ast node that provides source location information for
      generating error messages (it's only needed for the type_error generation)

    - tc contains the structure definition context
 *)
let rec typecheck_ty (l : 'a Ast.node) (tc : Tctxt.t) (t : Ast.ty) : unit =
  match t with
    | TInt -> ()                                              (* WF_TYPOKOKINT *)
    | TBool -> ()                                             (* WF_TYPOKOKBOOL *)
    | TRef rt -> typecheck_rty l tc rt                        (* WF_TYPOKOKREFT *)
    | TNullRef rt -> typecheck_rty l tc rt                    (* WF_TYPOKOKNULLREFT *)

and typecheck_rty (l : 'a Ast.node) (tc : Tctxt.t) (rt : Ast.rty) : unit =
  match rt with
    |RString -> ()                                            (* WF_REFTOKOSTRING *)
    |RArray t -> typecheck_ty l tc t                          (* WF_REFTOKOARRAY *)
    |RStruct id ->
      (match Tctxt.lookup_struct_option id tc with
        | Some _ -> ()                                        (* WF_REFTOKOSTRUCT *)
        | None -> type_error l ("Struct " ^ id ^ " not found"))

    |RFun (tls, rett) ->                                      (* WF_REFTOKOFUN *)
        List.iter (fun t -> typecheck_ty l tc t) tls;
        typecheck_retty l tc rett


and typecheck_retty (l : 'a Ast.node) (tc : Tctxt.t) (rett : Ast.ret_ty) : unit =
  match rett with
    | RetVoid -> ()                                           (* WF_RTYOKVOIDOK *)
    | RetVal t -> typecheck_ty l tc t                         (* WF_RTYOKRTYPOK *)

(* typechecking expressions ------------------------------------------------- *)
(* Typechecks an expression in the typing context c, returns the type of the
   expression.  This function should implement the inference rules given in the
   oad.pdf specification.  There, they are written:

       H; G; L |- exp : t

   See tctxt.ml for the implementation of the context c, which represents the
   four typing contexts: H - for structure definitions G - for global
   identifiers L - for local identifiers

   Returns the (most precise) type for the expression, if it is type correct
   according to the inference rules.

   Uses the type_error function to indicate a (useful!) error message if the
   expression is not type correct.  The exact wording of the error message is
   not important, but the fact that the error is raised, is important.  (Our
   tests also do not check the location information associated with the error.)

   Notes: - Structure values permit the programmer to write the fields in any
   order (compared with the structure definition).  This means that, given the
   declaration struct T { a:int; b:int; c:int } The expression new T {b=3; c=4;
   a=1} is well typed.  (You should sort the fields to compare them.)

*)
let rec typecheck_exp (c : Tctxt.t) (e : Ast.exp node) : Ast.ty =
  match e.elt with
    | CNull rty -> typecheck_rty e c rty; TNullRef rty                                          (* TYP_NULL *)
    | CBool b -> TBool                                                                          (* TYP_BOOL *)
    | CInt i -> TInt                                                                            (* TYP_INT  *)
    | CStr s -> TRef RString                                                                    (* TYP_STRING *)
    | Id id -> (match (lookup_local_option id c,lookup_global_option id c) with
        | (Some ty, _) -> ty                                                                    (* TYP_LOCAL *)
        | (None, Some ty) -> ty                                                                 (* TYP_GLOBAL *)
        | _ -> type_error e ("id   " ^ id ^ "   was not found in context in typecheck_exp"))
    | CArr (ty,expndls) ->
        typecheck_ty e c ty;
        let expndtyls = List.map (fun expnd -> typecheck_exp c expnd) expndls in (* Extract all types and check correctness*)
        let bools = List.map (fun expndty -> subtype c expndty ty) expndtyls in  (* Check if all extracted types are subtype of ty*)
        let cond = List.fold_right (fun b acc -> b && acc) bools true in         (* Fold booleans *)
        if cond then (TRef (RArray ty)) else type_error e ("condition for CArr was not met in typecheck_exp")   (* TYP_CARR *)                                                        (* TYP_ARR *)
    | NewArr (ty,expnd1,id,expnd2)->
        typecheck_ty e c ty;
        let cond1 = (typecheck_exp c expnd1) = TInt in
        let cond2 = if (lookup_local_option id c) = None then true else false in
        let tempc = Tctxt.add_local c id TInt in
        let t' = typecheck_exp tempc expnd2 in
        let cond4 = (subtype c t' ty) in
        if cond1 && cond2 && cond4 then (TRef (RArray ty)) else type_error e ("condition for NewArr was not met in typecheck_exp")   (* TYP_NEWARR *)

    | Index (expnd1,expnd2) -> (
        let expnd1ty = typecheck_exp c expnd1 in
        let expnd2ty = typecheck_exp c expnd2 in
        match (expnd1ty, expnd2ty) with
          | (TRef (RArray ty), TInt) -> ty
          | _ -> type_error e ("condition for Index was not met in typecheck_exp") )  (* TYP_INDEX *)
    | Length expnd ->
        typecheck_exp c expnd;
        TInt
    | CStruct (id, idexpndls) ->
        (* Sorting may be wrog... *)
        let s = match (Tctxt.lookup_struct_option id c) with
          | Some s -> s
          | None -> type_error e ("Struct " ^ id ^ " not found in context in typecheck_exp") in
        (*sort fields in s*)
        let fields = List.sort (fun field1 field2 -> compare field1.fieldName field2.fieldName) s in
        (*extract types from fields in s*)
        let fieldtyls = List.map (fun field -> field.ftyp) fields in
        (*sort fields in expndls*)
        let idexpndls = List.sort (fun (id1, expnd1) (id2, expnd2) -> compare id1 id2) idexpndls in
        (*extract types from expndls*)
        let expndtyls = List.map (fun (id, expnd) -> typecheck_exp c expnd) idexpndls in
        (* check if lists have same length otherweise throw error *)
        let condLength = (List.length fieldtyls) = (List.length expndtyls) in
        if not condLength then type_error e ("wrong amount of arguments for CStruct in typecheck_exp") else
        (*for each type t_i' in expndtyls check if subtype of t_i in s*)
        let bools = List.map2 (fun expndty fieldty -> subtype c expndty fieldty) expndtyls fieldtyls in
        (*fold booleans*)
        let cond = List.fold_right (fun b acc -> b && acc) bools true in
        if cond then (TRef (RStruct id)) else type_error e ("condition for CStruct was not met in typecheck_exp")   (* TYP_CSTRUCT *)

    | Proj (expn,id) ->
        let expndty = typecheck_exp c expn in
        (match expndty with
          | TRef (RStruct id') ->
              let s = match (Tctxt.lookup_struct_option id' c) with
                | Some s -> s
                | None -> type_error e ("Struct " ^ id' ^ " not found in context in typecheck_exp") in
                (* Try to find id in field and if it fails throw an error *)
              let field = try List.find (fun field -> field.fieldName = id) s
                          with | Not_found -> type_error e ("Field " ^ id ^ " not found in struct " ^ id') in
              field.ftyp
          | _ -> type_error e ("condition for Proj was not met in typecheck_exp"))   (* TYP_PROJ *)

    | Call (expnd, expndls) ->
        let expndty = typecheck_exp c expnd in
        let (argsTypes, rett) = match expndty with
          | TRef (RFun (argsTypes, rett)) -> (argsTypes, rett)
          | _ -> type_error e ("condition 1 for Call was not met in typecheck_exp") in
        let expndtyls = List.map (fun expnd -> typecheck_exp c expnd) expndls in
        (* Check if lists have same length and throw error if not *)
        let condLength = (List.length argsTypes) = (List.length expndtyls) in
        if not condLength then type_error e ("wrong amount of arguments for Call was not met in typecheck_exp") else
        let bools = List.map2 (fun expndty argty -> subtype c expndty argty) expndtyls argsTypes in
        (* print all the bools*)
        let cond = List.fold_right (fun b acc -> b && acc) bools true in
        let retty = match rett with
          | RetVal t -> t
          | RetVoid -> type_error e ("Call exp function has return type void") in
        if cond then retty else type_error e ("wrong types of arguments for Call was not met in typecheck_exp")   (* TYP_CALL *)

    | Bop (bop, expnd1, expnd2) ->
          let expnd1ty = typecheck_exp c expnd1 in
          let expnd2ty = typecheck_exp c expnd2 in
          typecheck_ty e c expnd1ty;
          typecheck_ty e c expnd2ty;
          begin match bop with
              |Neq |Eq -> if (expnd1ty = expnd2ty) then (Ast.TBool) else type_error e "Failed in tc_exp BOP Case Neq|Eq"

              |_->
                let (expected_ty1,expected_ty2,retty) = typ_of_binop bop in
                let cond1 = ((expected_ty1,expected_ty2) = (expnd1ty, expnd2ty)) in
                if cond1 then retty else type_error e ("Expected " ^ (string_of_ty expected_ty1) ^ " and " ^ (string_of_ty expected_ty2) ^ " but got " ^ (string_of_ty (expnd1ty)) ^ " and " ^ (string_of_ty (expnd2ty)))
          end


    | Uop (uop, expn) ->
        let (expected_ty, retty) = typ_of_unop uop in
        let expndty = typecheck_exp c expn in
        typecheck_ty e c expndty;
        if expected_ty = expndty then retty else type_error e ("Expected " ^ (string_of_ty expected_ty) ^ " but got " ^ (string_of_ty expndty))

(* statements --------------------------------------------------------------- *)

(* Typecheck a statement
   This function should implement the statement typechecking rules from oat.pdf.

   Inputs:
    - tc: the type context
    - s: the statement node
    - to_ret: the desired return type (from the function declaration)

   Returns:
     - the new type context (which includes newly declared variables in scope
       after this statement
     - A boolean indicating the return behavior of a statement:
        false:  might not return
        true: definitely returns

        in the branching statements, both branches must definitely return

        Intuitively: if one of the two branches of a conditional does not
        contain a return statement, then the entier conditional statement might
        not return.

        looping constructs never definitely return

   Uses the type_error function to indicate a (useful!) error message if the
   statement is not type correct.  The exact wording of the error message is
   not important, but the fact that the error is raised, is important.  (Our
   tests also do not check the location information associated with the error.)

   - You will probably find it convenient to add a helper function that implements the
     block typecheck rules.
*)
let typ_decl (tc: Tctxt.t) (vdecl: Ast.vdecl) : Tctxt.t =
  let (id, expnd) = vdecl in
  let cond1 = (lookup_local_option id tc) = None in
  let t = typecheck_exp tc expnd in
  let newc = if cond1 then (Tctxt.add_local tc id t) else (type_error expnd ("Variable " ^ id ^ " already declared in this scope")) in
  newc

let rec typecheck_stmt (tc : Tctxt.t) (s:Ast.stmt node) (to_ret:ret_ty) : Tctxt.t * bool =
  (*
        WORK IN PROGRESS
  *)
  match s.elt with
    | Assn (lhs_expnd, rhs_expnd) ->
        let t = (typecheck_exp tc lhs_expnd) in
        let inlocalcontext = (lookup_local_option (match lhs_expnd.elt with | Id id -> id | _ -> "") tc) = (Some t) in
        let lhsisglobalfunc = match lhs_expnd.elt with
          | Id id -> (
              match (lookup_global_option id tc) with
              | (Some (TRef (RFun (_)))) -> true
              | _ -> false)
          | _ -> false in
        let lhs_ty = typecheck_exp tc lhs_expnd in
        let rhs_ty = typecheck_exp tc rhs_expnd in
        let cond3 = subtype tc rhs_ty lhs_ty in
        if (inlocalcontext || not lhsisglobalfunc) then
          if cond3 then (tc,false)
          else type_error s ("condition 3 for Assn was not met in typecheck_stmt")
        else type_error s ("condition 1 and 2 for Assn was not met in typecheck_stmt")   (* TYP_ASSN *)
    | Decl (vdecl) -> (* Must be checked for correctness: Missing the rt in rule "H;G;L;rt |- ..."*)
        let tc' = typ_decl tc vdecl in
        (tc', false)
    | Ret (Some expnd) ->
        if to_ret = RetVoid then type_error s ("condition 1 for Ret was not met in typecheck_stmt") else
        let (RetVal t) = to_ret in
        let t' = typecheck_exp tc expnd in
        let cond2 = subtype tc t' t in
        if cond2 then (tc, true) else type_error s ("condition 2 for Ret was not met in typecheck_stmt")   (* TYP_RETT*)             (* TYP_RETT*)
    | Ret (None) -> (tc, true)                                                (* TYP_RETVOID*)
    | SCall (expnd, expndls) ->
        let expndty = typecheck_exp tc expnd in
        let (argsTypes, retty) = match expndty with
          | TRef (RFun (argsTypes, rett)) -> (argsTypes, rett)
          | _ -> type_error s ("condition 1 for SCall was not met in typecheck_stmt") in
        if retty != RetVoid then type_error s ("condition 1 for SCall was not met in typecheck_stmt") else
        let expndtyls = List.map (fun expnd -> typecheck_exp tc expnd) expndls in
        let bools = List.map2 (fun expndty argty -> subtype tc expndty argty) expndtyls argsTypes in
        (* print all the bools*)
        let cond = List.fold_right (fun b acc -> b && acc) bools true in
        if cond then (tc,false) else type_error s ("condition 2 for SCall was not met in typecheck_stmt")   (* TYP_CALL *)
    | If (expnd_cond, block_then, block_else) ->
        let expndty = typecheck_exp tc expnd_cond in
        let cond1 = expndty = TBool in
        let (tc', ret_then) = typecheck_stmts tc block_then to_ret in
        let (tc'', ret_else) = match block_else with
          |[] -> tc',false
          |_-> typecheck_stmts tc' block_else to_ret
        in

        let cond2 = ret_then && ret_else in
        if cond1
        then (tc, cond2)
        else type_error s ("condition 1 for If was not met in typecheck_stmt")   (* TYP_IF *)

    | Cast (rty, id, expnd_cond, block_then, block_else) ->
        let ref'_q = typecheck_exp tc expnd_cond in
        let ref' = match ref'_q with
          | TNullRef ref' -> ref'
          | _ -> type_error s ("exp was not of type TNullRef in Cast was not met in typecheck_stmt") in
        let cond1 = subtype_ref tc ref' rty in
        let (_,ret_then) = typecheck_stmts (Tctxt.add_local tc id (TRef rty)) block_then to_ret in
        let (_,ret_else) = match block_else with
          | [] -> (tc,false)
          | _ -> typecheck_stmts tc block_else to_ret in
          let cond2 = ret_then && ret_else in
          if cond1
          then (tc, cond2)
          else type_error s ("condition subtype for IfQ (Cast) was not met in typecheck_stmt")   (* TYP_IF *)



    | For (vdeclls, expnd_option, stmtnd_option, stmtndls) ->
        let tc' = List.fold_left typ_decl tc vdeclls in
        let cond1 = match expnd_option with
          | Some expnd -> typecheck_exp tc' expnd = TBool
          | None -> true in
        let (_, _) = typecheck_stmts tc' stmtndls to_ret in
        (tc, false)

    | While (expnd, stmtndls) ->
        let expndty = typecheck_exp tc expnd in
        let cond1 = expndty = TBool in
        let (tc', ret) = typecheck_stmts tc stmtndls to_ret in
        if cond1 then (tc', false)
        else type_error s ("condition 1 for While was not met in typecheck_stmt")   (* TYP_WHILE *)



    | _ -> failwith "todo: implement typecheck_stmt"


and typecheck_block (tc : Tctxt.t) (block:Ast.block) (to_ret:ret_ty) : Tctxt.t * bool =
  (*
        WORK IN PROGRESS
  *)
  let (c,returns) = typecheck_stmts tc block to_ret in
  if (returns = false)
    then type_error dummynode ("block doesnt return in typecheck_block")
    else (c,returns)

and typecheck_stmts (tc : Tctxt.t) (stmts:Ast.stmt node list) (to_ret:ret_ty) : Tctxt.t * bool =
  (*
     WORK IN PROGRESS
  *)
  let rec typecheck_stmts_rec (tc : Tctxt.t) (stmts:Ast.stmt node list) (to_ret:ret_ty) (returns:bool) : Tctxt.t * bool =
    match stmts with
      | [] -> (tc, returns)
      | h :: [] -> let (tc', ret) = typecheck_stmt tc h to_ret in
                    (tc',ret)

      | h :: t -> let (tc', ret) = typecheck_stmt tc h to_ret in
                  if (ret = true) then
                    type_error h ("a non-final stmt returns in typecheck_stmts")
                  else
                    typecheck_stmts_rec tc' t to_ret returns
  in
  typecheck_stmts_rec tc stmts to_ret false





(* struct type declarations ------------------------------------------------- *)
(* Here is an example of how to implement the TYP_TDECLOK rule, which is
   is needed elswhere in the type system.
 *)

(* Helper function to look for duplicate field names *)
let rec check_dup_ids (ids:Ast.id list) : bool =
  match ids with
    |[] -> false
    |i::is -> (List.fold_left ((fun acc x -> (acc || x = i))) false is || (check_dup_ids is))

(*This function checks glocal and struct context for dups and returns true if one of them contains dups*)
let dups_in_ctxt (tc:Tctxt.t) : bool =
  let {locals;globals;structs} = tc in
  let dups_in_glob = check_dup_ids (List.map fst globals) in
  let dups_in_structs = check_dup_ids (List.map fst structs) in
  (* let dups_in_locals = check_dup_ids (List.map fst locals) in *)
  (dups_in_glob || dups_in_structs)


let rec check_dups fs =
    match fs with
      | [] -> false
      | h :: t -> (List.exists (fun x -> x.fieldName = h.fieldName) t) || check_dups t

let typecheck_tdecl (tc : Tctxt.t) id fs  (l : 'a Ast.node) : unit =
  if check_dups fs
  then type_error l ("Repeated fields in " ^ id)
  else List.iter (fun f -> typecheck_ty l tc f.ftyp) fs

(* function declarations ---------------------------------------------------- *)
(* typecheck a function declaration
    - extends the local context with the types of the formal parameters to the
      function
    - typechecks the body of the function (passing in the expected return type
    - checks that the function actually returns
*)


let rec add_args_to_ctxt (c:Tctxt.t) (fargs: (ty*id) list) : Tctxt.t =
  match fargs with
  |[] -> c
  |(ty,id)::restargs -> add_args_to_ctxt (Tctxt.add_local c id ty) restargs


(*{frtyp : ret_ty; fname : id; args : (ty * id) list; body : block} *)
let typecheck_fdecl (tc : Tctxt.t) (f : Ast.fdecl) (l : 'a Ast.node) : unit =
  let {frtyp;fname;args=fargs;body } = f in
  let dup_args = check_dup_ids (List.map snd fargs) in           (* args have distinct id*)
  if (not dup_args) then () else type_error l "not all args distinct";
  let tc = add_args_to_ctxt tc fargs in
  let (tc,returns) = typecheck_block tc body frtyp in
  if (not returns) then type_error l "function doesnt return" else ();



()


(* creating the typchecking context ----------------------------------------- *)

(* The following functions correspond to the
   judgments that create the global typechecking context.

   create_struct_ctxt: - adds all the struct types to the struct 'H'
   context (checking to see that there are no duplicate fields

     H |-s prog => H'


   create_function_ctxt: - adds the the function identifiers and their
   types to the 'G' context (ensuring that there are no redeclared
   function identifiers)

     H ; G1 |-f prog ==> G2


   create_global_ctxt: - typechecks the global initializers and adds
   their identifiers to the 'G' global context

     H ; G1 |-g prog ==> G2


   NOTE: global initializers may mention function identifiers as
   constants, but can't mention other global values *)

let create_struct_ctxt (p:Ast.prog) : Tctxt.t =
  (*
        WORK IN PROGRESS
  *)
  let rec add_decls (tc : Tctxt.t) (decl: Ast.decl) =
    match decl with
    | Gtdecl ({elt=(id, fs)} as l) ->
      (* check if id is in the context already and if so throw an error *)
      if (Tctxt.lookup_struct_option id tc) != None then type_error l ("Struct " ^ id ^ " already declared in this scope") else
      let tc' = Tctxt.add_struct tc id fs in
      typecheck_tdecl tc' id fs l;
      tc'

    (*| Gvdecl ({elt=g}) -> (
        let {name = id; init = expnd} = g in
        print_endline ("adding " ^ id ^ " to global context");
        let t = typecheck_exp tc expnd in
        Tctxt.add_global tc id t) *)
    | _ -> tc
  in
  List.fold_left add_decls Tctxt.empty p



let create_function_ctxt (tc:Tctxt.t) (p:Ast.prog) : Tctxt.t =
  (*
        WORK IN PROGRESS
  *)
  let rec typecheck_args (tc:Tctxt.t) (args: (Ast.ty * Ast.id) list) : unit =
    match args with
    | [] -> ()
    | (t, id) :: rest ->
      typecheck_ty dummynode tc t;
      typecheck_args tc rest
  in

  let rec add_fdecls (tc : Tctxt.t) (decls: Ast.decl list) : Tctxt.t =
    match decls with
    | [] -> tc
    | decl :: rest ->
      match decl with
      | Gfdecl ({elt=f} as l) ->
          (* check if f is already in the ctxt and if so throw an error *)
          if (Tctxt.lookup_global_option f.fname tc) != None then type_error l ("Function " ^ f.fname ^ " already declared in this scope") else
          let argsTypes = List.map (fun (t,_) -> t) f.args in
          typecheck_args tc f.args;
          typecheck_retty l tc f.frtyp;
          Tctxt.add_global (add_fdecls tc rest) f.fname (TRef (RFun (argsTypes, f.frtyp)))
      | _ -> add_fdecls tc rest
  in
  let tc' = add_fdecls tc p in
  (* add builtins *)
  List.fold_left (fun tc (id, (argsTypes, rett)) -> Tctxt.add_global tc id (TRef (RFun (argsTypes, rett)))) tc' builtins


let create_global_ctxt (tc:Tctxt.t) (p:Ast.prog) : Tctxt.t =
  (*
        WORK IN PROGRESS
  *)
  let rec check_if_contains_global (expnd:Ast.exp node) (added_ids : string list) : bool =
    match expnd.elt with
    | CNull _ | CBool _ | CInt _ | CStr _ -> false
    | Id id -> List.exists (fun x -> x = id) added_ids
    | CArr (_, expndls) -> List.exists (fun expnd -> check_if_contains_global expnd added_ids) expndls
    | NewArr (_, expnd1, _, expnd2) -> (check_if_contains_global expnd1 added_ids) || (check_if_contains_global expnd2 added_ids)
    | Index (expnd1, expnd2) -> (check_if_contains_global expnd1 added_ids) || (check_if_contains_global expnd2 added_ids)
    | Length expnd -> check_if_contains_global expnd added_ids
    | CStruct (_, idexpndls) -> List.exists (fun (id, expnd) -> check_if_contains_global expnd added_ids) idexpndls
    | Proj (expn, _) -> check_if_contains_global expn added_ids
    | Call (expnd, expndls) -> (check_if_contains_global expnd added_ids) || (List.exists (fun expnd -> check_if_contains_global expnd added_ids) expndls)
    | Bop (_, expnd1, expnd2) -> (check_if_contains_global expnd1 added_ids) || (check_if_contains_global expnd2 added_ids)
    | Uop (_, expn) -> check_if_contains_global expn added_ids
  in

  let rec add_gdecls (tc : Tctxt.t) (decls: Ast.decl list) (added_ids: string list) : Tctxt.t =
    match decls with
    | [] -> tc
    | decl :: rest ->
      match decl with
      | Gvdecl ({elt=vdecl} as l) -> (
          let {name = id; init = expnd} = vdecl in
          (* check that id is not in ctxt and if so throw an error *)
          if (Tctxt.lookup_global_option id tc) != None then type_error l ("Variable " ^ id ^ " already declared in this scope") else
          (* check that expnd does not contain any global variables *)
          if (check_if_contains_global expnd added_ids) then type_error l ("Variable " ^ id ^ " contains global variables") else
          let t = typecheck_exp tc expnd in
          let tc' = Tctxt.add_global tc id t in
          let added_ids' = id :: added_ids in
          add_gdecls tc' rest added_ids')
      | _ -> add_gdecls tc rest added_ids
  in
  add_gdecls tc p []


(* This function implements the |- prog and the H ; G |- prog
   rules of the oat.pdf specification.
*)
let typecheck_program (p:Ast.prog) : unit =
  let sc = create_struct_ctxt p in
  let fc = create_function_ctxt sc p in
  let tc = create_global_ctxt fc p in

  if (dups_in_ctxt tc) then type_error dummynode "duplicates in context" else ();

  List.iter (fun p ->
    match p with
    | Gfdecl ({elt=f} as l) -> typecheck_fdecl tc f l
    | Gtdecl ({elt=(id, fs)} as l) -> typecheck_tdecl tc id fs l
    | _ -> ()) p