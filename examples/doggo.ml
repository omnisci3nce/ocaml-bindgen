(* automatically generated by ocaml-bindgen 0.0.1 *)
type nonrec breed =
  | C_Labrador 
  | C__GoldenRetriever 
  | C_pug 
  | C__poodle 
type nonrec doggo = {
  many: int ;
  breed: breed ;
  wow: char ;
  weight: float }
external eleven_out_of_ten_majestic_af :
  pupper:doggo -> unit = "caml_eleven_out_of_ten_majestic_af"
external no_input_no_output : unit -> unit = "caml_no_input_no_output"
