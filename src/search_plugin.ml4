(*i camlp4deps: "parsing/grammar.cma" i*)
(*i camlp4use: "pa_extend.cmp" i*)

(**
*)


(* Arcane incantations  *)
let _ = Mltop.add_known_module "Search_plugin"

let _ = Pp.msgnl (Pp.str "Loading the Search plugin")

open Tacexpr
open Tacinterp
open Tacenv
open Declarations

open Names (* kernel/names.mli *)

open String
open Prettyp
open Pp
open Str

(** Output options *)

type formatOptions = | FmtQualified
                     | FmtShortId
                     | FmtBoth
;;

let  debug        = ref false
let  format       = ref FmtShortId

(** deal with our extended patterns (beyond Str.regexp) *)
type pattSpec = {
    mutable noCase: bool ;
    mutable hasLast: bool;   (* "<l>" has been used *)
    mutable rexOrSepL: Str.regexp list ; 
};;

(** prepare the string patt which may be an extended pattern i.e. contain <lic>*)
let prepPattern = fun patt ->
    let rexSplit = Str.regexp "<[licLIC]>"
    in let pattList = Str.full_split rexSplit patt
       and retSpec  = {noCase = false ; hasLast = false; rexOrSepL = [] }
    in let plAna = function  
      Text  t -> if t != ""
	         then let rexCompiler = if ( retSpec.noCase )
		                          then Str.regexp_case_fold
			                  else Str.regexp 
                 in retSpec.rexOrSepL <-
		   let rex = try rexCompiler t
		             with _ -> raise (Invalid_argument  ( concat "" [
			                         "Unable to compile regexpr:\""; t ;
					          "\" not Ocaml Str compliant." ]))
		   in     
		   List.append retSpec.rexOrSepL [ rex ]
     |Delim d -> if d = "<i>" || d = "<I>"
                 then  retSpec.noCase <- true
		 else if d = "<c>" || d = "<C>"
                 then  retSpec.noCase <- false
	         else if d = "<l>" || d = "<L>"
		    then retSpec.hasLast <- true
		    else raise ( 
		       Invalid_argument ( concat ""
		           [ "Bad extended tag in regexpr:\"";
		              d ; "\" not <[li]>" ]))
    in List.iter plAna pattList ;
       retSpec

let dbg_string_match = fun rex str pos ->
     pp (Pp.str (concat " " ["Debug string match of string:" ;
                             str; "at pos"; (string_of_int pos) ; "\n" ]));
     string_match rex str pos

let pattMatch = fun (pSpec: pattSpec) str ->
    let  matcher = if !debug then dbg_string_match else string_match
    in if pSpec.hasLast
        then
          let dotIdx = rindex str '.'
	  in
            if List.length pSpec.rexOrSepL = 1
	      then    matcher (List.hd pSpec.rexOrSepL) str (dotIdx+1)
	      else    matcher (List.hd pSpec.rexOrSepL)
	                               (sub str 0 dotIdx) 0
	           && matcher (List.nth pSpec.rexOrSepL 1 ) str (dotIdx+1)
        else
          matcher (List.hd pSpec.rexOrSepL) str 0
	  
(** select entries according to the regexp *)
     (*  theMap :  Tacenv.ltac_entry Names.KNmap.t *)
let select_tac_entries = fun theMap pattern ->
    let theSpec = prepPattern pattern
    in let rexSelect = fun key  -> pattMatch theSpec (KerName.to_string key)
    in  (* iterate on the map; keys appear in the order defined on
           [KerName]s, by the compare function found in ./kernel/names.ml. 
        *)
       let map_visitor = fun key entry ->
          if (rexSelect key) then
              pp (str (concat "" [ "Key = " ; (KerName.to_string key) ; "\n"] ))
    in
    Names.KNmap.iter map_visitor  theMap     

		  
;;

(** perform the filtering over the map returned by  ltac_entries(),
    which is defined by Coq in ./tactics/tacenv.mli                  *)
let filterAccessLtacs = fun regex ->
    let theMap = ltac_entries() in
	 select_tac_entries theMap regex
;;


(** Function handling the simplest command [SearchLtac] *)
let searchFromRegex = fun (strarg : string) ->
     pp ( Pp.str (concat " " [ "Searching from regexp:" ; strarg ; "\n" ]));
     pp_flush();
     try
         filterAccessLtacs strarg
     with
       | Invalid_argument msg ->
            raise ( Errors.UserError (" " , (Pp.str (concat " " ["Error" ; msg ;"\n"]))))
       |  _                   ->
            raise ( Errors.UserError (" ", (Pp.str (concat " "
                                      ["An error has occurred" ; "\n"]))))
;;

(** This is the simplest command *)
VERNAC COMMAND EXTEND SearchLtac
 ["SearchLtac" string(searchRegex) ] -> [ searchFromRegex searchRegex  ]
END;;



