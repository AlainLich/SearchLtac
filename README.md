# A Coq plugin that  defines vernacular commands for searching Ltacs

## Purpose
  This plugin defines a new vernacular command [SearchLtac pattern ].
  The result is the list of (fully qualified) names of available Ltacs which match
  the pattern.

Note: this version is highly experimental, and tested only on Coq8.5rc1






## Patterns

 1 -  The pattern language has been taken from ocaml (see reference manual chap. 24.1).
 2 -  It is  extended in the following way
                              
|:------------|:------------------------------|
| <l>         | Last component follows (appears once)       |
| <i>         | Case insensitive comparison   |
| <c>         | Case sensitive comparison   |
|:------------|:------------------------------|

## Optional arguments / options state 
  All of this is *planned* (i.e. not done yet):
  A number of state variables are available, to be set up by a special syntax, for
  now we are not using the general Set mechanism (which prevents interference ....)
 1 - Show the outcome starting with the Ltac name
 2 - Verbosity level

## Examples


|:---------------------------------------|:---------------------------------|
| SearchLtac  ".*intro$".                | Key = Coq.Init.Notations.intro   |
| SearchLtac  ".*intro".                 | Key = LibTac.intro_until_mark    |
|                                        | Key = LibTac.introv_arg          |
|                                        | Key = LibTac.introv_rec          |
|                                        | Key = LibTac.intro_until_pat     |
|                                        |    ...                           |
| SearchLtac  "".                        |  All LTacs                       |
| SearchLtac  ".*ssreflect.*".           |  ssreflect tactics               |
| SearchLtac  ".*Z.*".                   | Key = Coq.ZArith.BinInt.Z.order_pos |
|                                        | Key = Coq.setoid_ring.InitialRing.inv_gen_phiZ |
|                                        | Key = Coq.ZArith.BinInt.Z.order' |
| SearchLtac  ".*\.Z\..*".               |                                  |
| SearchLtac  ".*destr.*".               |                                  |
| SearchLtac  ".*apply.*".               |                                  |
| SearchLtac  ".*intro$".                |                                  |
| SearchLtac  "<l>.*ve.*".               |
| SearchLtac  ".*Ar.*<l>.*ve.*".         |  |
| SearchLtac ".*Class.*<l>\(pro\|sub\).*".| |
|----------------------------------------|----------------------------------|
