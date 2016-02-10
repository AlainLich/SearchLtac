Require Import String. 
Add Rec LoadPath "../src/" as Output.  
Add ML Path "../src/". 

Require  Dump. 


Section t. 
  Definition nb := 100.

  Fixpoint mk_list_rec (acc:list nat) (n : nat) :=
    match n with
      | O => (0, acc)
      | S n0 => mk_list_rec (n::acc) n0
    end.
  Definition mk_list n := mk_list_rec nil n.
  Time Eval vm_compute in mk_list 1000.
End t. 

Definition out := mk_list 100. 

Output out as "foo1.dump". 
