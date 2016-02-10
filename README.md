An example of Coq plugin that  defines vernacular commands for searching
Ltacs

- This plugin defines a new vernacular command [SearchTac pattern foo].


- The final pretty-printing is done using the current state of the
  pretty-printing machine: opening the right scopes, and defining
  notations may make a huge difference in terms of what the output
  looks like.


Note: this version is highly experimental, and tested only on Coq8.5rc1



 




