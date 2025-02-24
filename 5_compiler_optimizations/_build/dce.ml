(** Dead Code Elimination  *)
open Ll
open Datastructures


(* expose a top-level analysis operation ------------------------------------ *)
(* TASK: This function should optimize a block by removing dead instructions
   - lb: a function from uids to the live-OUT set at the 
     corresponding program point
   - ab: the alias map flowing IN to each program point in the block
   - b: the current ll block

   Note: 
     Call instructions are never considered to be dead (they might produce
     side effects)

     Store instructions are not dead if the pointer written to is live _or_
     the pointer written to may be aliased.

     Other instructions are dead if the value they compute is not live.
    
   Hint: Consider using List.filter
 *)
 (* type block = { insns : (uid * insn) list; term : (uid * terminator) }*)
  let isLive (op:Ll.operand) (l_set:Liveness.Fact.t) : bool =
    match op with
      |Id id -> 
        let l_string = try UidS.find id l_set with Not_found -> "" in
        begin match l_string with
          |"" -> false
          |_  -> true
        end
      |Gid gid -> true
      |Const c -> failwith "calling isLive on Const"
      |Null -> failwith "calling isLive on Null"
    

    


  let isAlias (op:Ll.operand) (a_map :Alias.fact) : bool =
    let uid = match op with
      |Id id -> id
      |Gid gid -> gid
      |Const c -> failwith "calling isAlias on Const"
      |Null -> failwith "calling isAlias on Null"
    in

    let a_val = UidM.find_or (Alias.SymPtr.UndefAlias) a_map uid in
    match a_val with
      |Alias.SymPtr.MayAlias -> true
      |_ -> false

 let notDeadCode (lb:uid -> Liveness.Fact.t) (ab:uid -> Alias.fact) ((uid ,insn) : uid * insn) : bool =
  let l_set = lb uid in
  let a_map = ab uid in 
  begin match insn with
    |Call (_,_,_) -> true
    |Store (ty,op1,op2) ->
      let live = isLive op2 l_set in 
      let alias = isAlias op2 a_map in
      let notDead = (live || alias) in
      (* if (not notDead) then (print_endline ("insn "^(Llutil.string_of_insn insn)^" is dead -> optimizing")) else (); *)
      notDead 
    |_ -> isLive (Id uid) l_set    
  end


let dce_block (lb:uid -> Liveness.Fact.t) 
              (ab:uid -> Alias.fact)
              (b:Ll.block) : Ll.block =

    let {insns;term} = b in
    let new_insns = List.filter (notDeadCode lb ab) (insns) in 
    ({insns=new_insns;term})
  

let run (lg:Liveness.Graph.t) (ag:Alias.Graph.t) (cfg:Cfg.t) : Cfg.t =

  LblS.fold (fun l cfg ->
    let b = Cfg.block cfg l in

    (* compute liveness at each program point for the block *)
    let lb = Liveness.Graph.uid_out lg l in

    (* compute aliases at each program point for the block *)
    let ab = Alias.Graph.uid_in ag l in 

    (* compute optimized block *)
    let b' = dce_block lb ab b in
    Cfg.add_block l b' cfg
  ) (Cfg.nodes cfg) cfg

