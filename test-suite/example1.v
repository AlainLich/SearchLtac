Require Import String. 
Add Rec LoadPath "../src/" as Search.  
Add ML Path "../src/". 

Require  SearchTac. 


Section t. 
  Require Import ZArith. 
  Open Scope Z_scope.
  SearchLtac ".*intro.*".
End t. 

SearchLtac ".*intro.*".
SearchLtac ".*clear.*".

