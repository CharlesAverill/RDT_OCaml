open Logging

type message =
  (* sequence number, character *)
  | DATA of (int * char) (* sequence number *)
  | ACK of int

let bytes_of_char_list (l : char list) : bytes =
  Bytes.concat Bytes.empty (List.map (fun c -> Bytes.make 1 c) l)

let char_list_of_bytes (b : bytes) : char list =
  let l = ref [] in
  for i = 0 to Bytes.length b - 1 do
    l := Bytes.get b i :: !l
  done ;
  List.rev !l

let int63_to_bytes (n : int) : bytes =
  bytes_of_char_list
    (List.map
       (fun i -> Char.chr ((n lsr (i * 8)) land 0xFF))
       [0; 1; 2; 3; 4; 5; 6; 7] )

let bytes_to_int63 (b : bytes) : int =
  if Bytes.length b != 8 then
    raise
      (Invalid_argument
         ( "bytes_to_int63 expects 8 bytes, got "
         ^ string_of_int (Bytes.length b) ) )
  else
    List.fold_left (fun a b -> a + int_of_char b) 0 (char_list_of_bytes b)

let encode_msg : message -> bytes = function
  | DATA (seq, c) ->
      Bytes.of_string
        (String.concat " " ["DATA"; string_of_int seq; String.make 1 c])
  | ACK seq ->
      Bytes.of_string (String.concat " " ["ACK"; string_of_int seq])

let is_whitespace = function
  | ' ' | '\t' | '\n' | '\r' | '\000' ->
      true
  | _ ->
      false

let strip s =
  let len = String.length s in
  let rec left_index i =
    if i < len && is_whitespace s.[i] then
      left_index (i + 1)
    else
      i
  in
  let rec right_index i =
    if i >= 0 && is_whitespace s.[i] then
      right_index (i - 1)
    else
      i
  in
  let start = left_index 0 in
  let stop = right_index (len - 1) in
  if start > stop then
    ""
  else
    String.sub s start (stop - start + 1)

let decode_msg (b : bytes) : message option =
  match String.split_on_char ' ' (Bytes.to_string b) with
  | ["DATA"; seq; c] ->
      let seq, c = (strip seq, strip c) in
      _log Log_Debug (Printf.sprintf "Decode result: DATA %s %s" seq c) ;
      Some (DATA (int_of_string seq, String.get c 0))
  | ["ACK"; seq] ->
      let seq = strip seq in
      _log Log_Debug (Printf.sprintf "Decode result: ACK %s" seq) ;
      Some (ACK (int_of_string seq))
  | _ ->
      _log Log_Error
        ("Tried to decode unrecognized message: " ^ Bytes.to_string b) ;
      None
