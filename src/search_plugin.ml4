(*i camlp4deps: "parsing/grammar.cma" i*)
(*i camlp4use: "pa_extend.cmp" i*)

(**
*)


(* Arcane incantations  *)
let _ = Mltop.add_known_module "Search_plugin"

let _ = Pp.msgnl (Pp.str "Loading the Search plugin")

open Tacexpr
open Tacinterp
open Declarations

let pp_constr fmt x = Pp.pp_with fmt (Printer.pr_constr x)

VERNAC COMMAND EXTEND PrintTimingProfile
 ["Output" global(cref) "as" string(file) ] ->
   [ 
   ]
END;;

