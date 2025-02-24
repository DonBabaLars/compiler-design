open Ll
open Datastructures

(* The lattice of symbolic constants ---------------------------------------- *)
module SymConst =
  struct
    type t = NonConst           (* Uid may take on multiple values at runtime *)
           | Const of int64     (* Uid will always evaluate to const i64 or i1 *)
           | UndefConst         (* Uid is not defined at the point *)

    let compare s t =
      match (s, t) with
      | (Const i, Const j) -> Int64.compare i j
      | (NonConst, NonConst) | (UndefConst, UndefConst) -> 0
      | (NonConst, _) | (_, UndefConst) -> 1
      | (UndefConst, _) | (_, NonConst) -> -1

    let to_string : t -> string = function
      | NonConst -> "NonConst"
      | Const i -> Printf.sprintf "Const (%LdL)" i
      | UndefConst -> "UndefConst"

    
  end

(* The analysis computes, at each program point, which UIDs in scope will evaluate 
   to integer constants *)
type fact = SymConst.t UidM.t



(* flow function across Ll instructions ------------------------------------- *)
(* - Uid of a binop or icmp with const arguments is constant-out
   - Uid of a binop or icmp with an UndefConst argument is UndefConst-out
   - Uid of a binop or icmp with an NonConst argument is NonConst-out
   - Uid of stores and void calls are UndefConst-out
   - Uid of all other instructions are NonConst-out
 *)
let quad_to_int (i:int64) : int = Int64.to_int i 

let int_to_quad (i:int) : int64 = Int64.of_int i
 
let analyzeOperand (op:Ll.operand) (map:fact) : SymConst.t =
  match op with
    |Ll.Const i -> Const i
    |Ll.Id uid -> UidM.find_or SymConst.UndefConst map uid    (*MIGHT BE FISHY*)
    |Null -> failwith "passing Null operand to analyzeOperand"
    |Gid gid -> failwith "passing Gid operand to analyzeOperand"
  
let applyBinop (bop:bop) (sym1:SymConst.t) (sym2:SymConst.t) : SymConst.t = (*returns a Const*)
  match bop,sym1,sym2 with
    | Add, Const i1,Const i2 -> Const (Int64.add i1 i2)
    | Sub, Const i1,Const i2 -> Const (Int64.sub i1 i2)
    | Mul, Const i1,Const i2 -> Const (Int64.mul i1 i2)
    | Shl, Const i1,Const i2 -> Const (Int64.shift_left i1 (quad_to_int i2))
    | Lshr, Const i1,Const i2 -> Const (Int64.shift_right_logical i1 (quad_to_int i2))
    | Ashr, Const i1,Const i2 -> Const (Int64.shift_right i1 (quad_to_int i2))
    | And, Const i1,Const i2 -> Const (Int64.logand i1 i2)
    | Or, Const i1,Const i2 -> Const (Int64.logor i1 i2)
    | Xor, Const i1,Const i2 -> Const (Int64.logxor i1 i2)
    |_-> (print_endline ((Llutil.string_of_bop bop)^", "^(SymConst.to_string sym1)^", "^(SymConst.to_string sym2)));failwith "bad input for applyBinop"

let applyIcmp (cnd:Ll.cnd) (sym1:SymConst.t) (sym2:SymConst.t) : SymConst.t =
  match cnd,sym1,sym2 with
  | Eq, Const i1, Const i2 -> if (i1 = i2) then (Const (int_to_quad 1)) else (Const (int_to_quad 0))
  | Ne, Const i1, Const i2 -> if (i1 = i2) then (Const (int_to_quad 0)) else (Const (int_to_quad 1))
  | Slt, Const i1, Const i2 -> if (i1 < i2) then (Const (int_to_quad 1)) else (Const (int_to_quad 0))
  | Sle, Const i1, Const i2 -> if (i1 <= i2) then (Const (int_to_quad 1)) else (Const (int_to_quad 0))
  | Sgt, Const i1, Const i2 -> if (i1 > i2) then (Const (int_to_quad 1)) else (Const (int_to_quad 0))
  | Sge, Const i1, Const i2 -> if (i1 >= i2) then (Const (int_to_quad 1)) else (Const (int_to_quad 0))
  |_-> failwith "bad input for applyIcmp"


let insn_flow (u,i:uid * insn) (d:fact) : fact =
  match i with
  (*CASE 1: Binop*)
  |Binop (bop,ty,op1,op2) -> 
    let (sym1,sym2) = (analyzeOperand op1 d, analyzeOperand op2 d) in
    begin match sym1,sym2 with
      (* Both Args Const *)
      |Const i1,Const i2 -> UidM.add u (applyBinop bop sym1 sym2) d
      (* One Arg is undef Const *)
      |UndefConst, _   
      |_, UndefConst  -> UidM.add u SymConst.UndefConst d
      (* One Arg NonConst*)
      |NonConst,_
      |_,NonConst -> UidM.add u SymConst.NonConst d
      |_ -> failwith "bad case in Constprop Binop insn_flow"
    end
  (*CASE 2:  ICmp *)
  |Icmp (cnd,ty,op1,op2) ->
    if (op1 = Null || op2 = Null) 
      then 
        UidM.add u SymConst.NonConst d

      else
        let (sym1,sym2) = (analyzeOperand op1 d, analyzeOperand op2 d) in
        begin match sym1,sym2 with
          (* Both Args Const *)
          |Const i1,Const i2 -> UidM.add u (applyIcmp cnd sym1 sym2) d
          (* One Arg is undef Const *)
          |UndefConst, _   
          |_, UndefConst  ->  UidM.add u SymConst.UndefConst d
          (* One Arg NonConst*)
          |NonConst,_
          |_,NonConst -> UidM.add u SymConst.NonConst d
          |_ -> failwith "bad case in Constprop Icmp insn_flow"
        end
  (*CASE 3,4: Voidcalls and Stores *)
  |Call (Void,_,_) 
  |Store (_,_,_) -> UidM.add u SymConst.UndefConst d
  
  (*CASE 5: All other instructions*)
  |_ -> UidM.add u SymConst.NonConst d
  

(* The flow function across terminators is trivial: they never change const info *)
let terminator_flow (t:terminator) (d:fact) : fact = d

(* module for instantiating the generic framework --------------------------- *)
module Fact =
  struct
    type t = fact
    let forwards = true

    let insn_flow = insn_flow
    let terminator_flow = terminator_flow
    
    let normalize : fact -> fact = 
      UidM.filter (fun _ v -> v != SymConst.UndefConst)

    let compare (d:fact) (e:fact) : int  = 
      UidM.compare SymConst.compare (normalize d) (normalize e)

    let to_string : fact -> string =
      UidM.to_string (fun _ v -> SymConst.to_string v)


    (* The constprop analysis should take the meet over predecessors to compute the
       flow into a node. You may find the UidM.merge function useful *)
  let combineSymConsts (v1:SymConst.t) (v2:SymConst.t) : SymConst.t =
    match v1,v2 with
      |Const i1,Const i2 -> if (i1 = i2) then (Const i1) else (NonConst)
      |NonConst,_ -> NonConst
      |_,NonConst -> NonConst
      |UndefConst,_ -> UndefConst
      |_,UndefConst -> UndefConst
    
  let combine (ds:fact list) : fact = 
      let f _ maybe1 maybe2 = match maybe1,maybe2 with
        |Some v1, Some v2 -> Some (combineSymConsts v1 v2)
        |None, Some v2 -> Some v2
        |Some v1, None -> Some v1
        |None,None -> None
      in
      let join d1 d2 = UidM.merge f d1 d2 in
      List.fold_left join UidM.empty ds
end

(* instantiate the general framework ---------------------------------------- *)
module Graph = Cfg.AsGraph (Fact)
module Solver = Solver.Make (Fact) (Graph)

(* expose a top-level analysis operation ------------------------------------ *)
let analyze (g:Cfg.t) : Graph.t =
  (* the analysis starts with every node set to bottom (the map of every uid 
     in the function to UndefConst *)
  let init l = UidM.empty in

  (* the flow into the entry node should indicate that any parameter to the
     function is not a constant *)
  let cp_in = List.fold_right 
    (fun (u,_) -> UidM.add u SymConst.NonConst)
    g.Cfg.args UidM.empty 
  in
  let fg = Graph.of_cfg init cp_in g in
  Solver.solve fg


(* run constant propagation on a cfg given analysis results ----------------- *)
(* HINT: your cp_block implementation will probably rely on several helper 
   functions.                                                                 *)

let replace_operand (cp_set:fact) (op:Ll.operand) : Ll.operand =
  match op with
    |Const i -> Const i
    |Null -> Null
    |Gid gid -> Gid gid
    |Ll.Id uid ->
      let Id uid = op in
        match (UidM.find_or SymConst.UndefConst cp_set uid) with
          |Const i -> Const i
          |NonConst -> op
          |UndefConst -> failwith "replace_operand: UndefConst"

let replace_ins (cb:uid -> fact) ((uid ,insn) : uid * insn) : (uid * insn) =
  let cp_set = cb uid in
  match insn with
    | Binop (bop, ty, op1, op2) ->
        let new_op1 = replace_operand cp_set op1 in
        let new_op2 = replace_operand cp_set op2 in
        (uid, Binop (bop, ty, new_op1, new_op2))
    | Alloca _ -> (uid, insn)
    | Load (ty, op) -> (uid, insn)
    | Store (ty, op1, op2) ->
        let new_op1 = replace_operand cp_set op1 in
        (uid, Store (ty, new_op1, op2))
    | Icmp (cnd, ty, op1, op2) ->
        let new_op1 = replace_operand cp_set op1 in
        let new_op2 = replace_operand cp_set op2 in
        (uid, Icmp (cnd, ty, new_op1, new_op2))
    | Call (ty, op, args) ->
        let new_args = List.map (fun (ty, op) -> (ty, replace_operand cp_set op)) args in
        (uid, Call (ty, op, new_args))
    | Bitcast (ty, op, ty2) -> (uid, insn)
    | Gep (ty, op, idxs) -> (uid, insn)

let replace_term (cb:uid -> fact) ((uid,term): uid * terminator) : (uid * terminator) =
  match term with
    | Ret (typ, Some op) -> (uid, Ret (typ, Some (replace_operand (cb uid) op)))
    | Ret (typ, None) -> (uid, term)
    | Br lbl -> (uid, term)
    | Cbr (op, lb1, lb2) -> (uid, Cbr ((replace_operand (cb uid) op), lb1, lb2))



let run (cg:Graph.t) (cfg:Cfg.t) : Cfg.t =
  let open SymConst in
  

  let cp_block (l:Ll.lbl) (cfg:Cfg.t) : Cfg.t =
    let b = Cfg.block cfg l in
    let cb = Graph.uid_out cg l in
    

    let {insns;term} = b in
    let new_insns = List.map (replace_ins cb) (insns) in 
    let new_term = replace_term cb term in
    let new_block = ({insns=new_insns;term=new_term}) in

    (* replace block in cfg*)
    Cfg.add_block l new_block cfg

  in

  LblS.fold cp_block (Cfg.nodes cfg) cfg
