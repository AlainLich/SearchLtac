Require Import String. 
Add Rec LoadPath "../src/" as Search.  
Add ML Path "../src/". 

Require  SearchTac. 


SearchLtac ".*tro.*". 
SearchLtac ".*intro.*".
SearchLtac ".ssref.*".
SearchLtac "<l>.ssref.*".
SearchLtac "<l>intro".
SearchLtac "<l>.*ve.*".
SearchLtac ".*Ar.*<l>.*ve.*".
SearchLtac ".*\.Ar.*<l>.*ve.*".
SearchLtac ".*[.]Ar.*<l>.*ve.*".
SearchLtac "<l>shelve$".
SearchLtac "<l>\(pro\|sub\).*".
SearchLtac ".*Class.*<l>\(pro\|sub\).*".


