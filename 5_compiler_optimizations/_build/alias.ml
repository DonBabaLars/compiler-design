(** Alias Analysis *)

open Ll
open Datastructures

(* The lattice of abstract pointers ----------------------------------------- *)
module SymPtr =
  struct
    type t = MayAlias           (* uid names a pointer that may be aliased *)
           | Unique             (* uid is the unique name for a pointer *)
           | UndefAlias         (* uid is not in scope or not a pointer *)

    let compare : t -> t -> int = Pervasives.compare

    let to_string = function
      | MayAlias -> "MayAlias"
      | Unique -> "Unique"
      | UndefAlias -> "UndefAlias"

  end

(* The analysis computes, at each program point, which UIDs in scope are a unique name
   for a stack slot and which may have aliases *)
type fact = SymPtr.t UidM.t

(* flow function across Ll instructions ------------------------------------- *)
(* TASK: complete the flow function for alias analysis. 

   - After an alloca, the defined UID is the unique name for a stack slot
   - A pointer returned by a load, call, bitcast, or GEP may be aliased
   - A pointer passed as an argument to a call, bitcast, GEP, or store
     may be aliased
   - Other instructions do not define pointers

 *)

let extract_uid = function
  | Id u -> u
  | Gid u -> u
  | _ -> failwith "extract_uid: not (G)ID"
let insn_flow ((u,i):uid * insn) (d:fact) : fact =
  match i with
  | Alloca _ -> UidM.add u SymPtr.Unique d
  | Load (ty, op) -> 
      (match ty with 
        | Ptr (Ptr _) -> UidM.add u SymPtr.MayAlias d
        | _ -> d )
  | Call (ty, op, args) ->
      let d = match ty with
        | Ptr _ -> UidM.add u SymPtr.MayAlias d
        | _ -> d in
      let rec add_args d args = match args with
        | [] -> d
        | (ty, op) :: args -> 
            (match ty with
              | Ptr _ -> UidM.add (extract_uid op) SymPtr.MayAlias d
              | _ -> add_args d args) in
      add_args d args
      
  | Bitcast (ty, op, ty') -> 
      (
      let d = match ty' with 
        | Ptr _ -> UidM.add u SymPtr.MayAlias d
        | _ -> failwith "Alias: BitCast: Should always be Pointer!" in
      match ty with
        | Ptr _ -> UidM.add (extract_uid op) SymPtr.MayAlias d
        | _ -> failwith "Alias: BitCast: Should always be Pointer!" )
  | Gep (ty, op, idxs) ->
      (match ty with
        | Ptr (Ptr _) -> 
            let d = UidM.add u SymPtr.MayAlias d in
            UidM.add (extract_uid op) SymPtr.MayAlias d
        | Ptr _ ->
            UidM.add u SymPtr.MayAlias d
        | _ -> failwith "Alias: Gep: Should always be pointer!" )
  | Store (ty, op1, op2) ->
      (match ty with
        | Ptr _ -> UidM.add (extract_uid op2) SymPtr.MayAlias d
        | _ -> d)
  | _ -> d




(* The flow function across terminators is trivial: they never change alias info *)
let terminator_flow t (d:fact) : fact = d

(* module for instantiating the generic framework --------------------------- *)
module Fact =
  struct
    type t = fact
    let forwards = true

    let insn_flow = insn_flow
    let terminator_flow = terminator_flow
    
    (* UndefAlias is logically the same as not having a mapping in the fact. To
       compare dataflow facts, we first remove all of these *)
    let normalize : fact -> fact = 
      UidM.filter (fun _ v -> v != SymPtr.UndefAlias)

    let compare (d:fact) (e:fact) : int = 
      UidM.compare SymPtr.compare (normalize d) (normalize e)

    let to_string : fact -> string =
      UidM.to_string (fun _ v -> SymPtr.to_string v)

    (* TASK: complete the "combine" operation for alias analysis.

       The alias analysis should take the join over predecessors to compute the
       flow into a node. You may find the UidM.merge function useful.

       It may be useful to define a helper function that knows how to take the
       join of two SymPtr.t facts.
    *)

    let combine_sym_ptr a b =
      match a, b with

      | SymPtr.MayAlias, _ | _, SymPtr.MayAlias -> SymPtr.MayAlias
      | SymPtr.UndefAlias, x | x, SymPtr.UndefAlias -> x
      | SymPtr.Unique, SymPtr.Unique -> SymPtr.Unique
    
    let combine (ds:fact list) : fact =
      let f _ v1 v2 = match v1, v2 with
        | Some v1, Some v2 -> Some (combine_sym_ptr v1 v2)
        | None, (Some _ as v) | (Some _ as v), None -> v
        | None, None -> None
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
     in the function to UndefAlias *)
  let init l = UidM.empty in

  (* the flow into the entry node should indicate that any pointer parameter 
     to the function may be aliased *)
  let alias_in = 
    List.fold_right 
      (fun (u,t) -> match t with
                    | Ptr _ -> UidM.add u SymPtr.MayAlias
                    | _ -> fun m -> m) 
      g.Cfg.args UidM.empty 
  in
  let fg = Graph.of_cfg init alias_in g in
  Solver.solve fg

