open Unix
open Rdt.Messages
open Rdt.Logging

let seq_number = ref 0

let send_receive (sock : file_descr) sockaddr =
  (* Wait for an incoming message from the client *)
  let _ = select [sock] [] [] (-1.0) in
  let recvbuf = Bytes.create (16 + String.length (string_of_int !seq_number)) in
  let _, client_addr = recvfrom sock recvbuf 0 (Bytes.length recvbuf) [] in
  match decode_msg recvbuf with
  | Some (DATA (seq, c)) when seq = !seq_number ->
      (* Received DATA with correct seq number *)
      (* Print data character to the screen *)
      _log Log_Info ("Received: " ^ String.make 1 c) ;
      (* Send the appropriate ACK message to the client *)
      let msg = encode_msg (ACK seq) in
      let _ = sendto sock msg 0 (Bytes.length msg) [] client_addr in
      (* Increment the expected sequence number *)
      seq_number := 1 + !seq_number
  | Some (DATA (seq, c)) ->
	  (* Send a duplicate ACK to the client *)
	  let msg = encode_msg (ACK seq) in
	  let _ = sendto sock msg 0 (Bytes.length msg) [] client_addr in
	  ()
  | _ ->
      (* Malformed data received *)
      (* Send a duplicate ACK to the client *)
      let msg = encode_msg (ACK !seq_number) in
      let _ = sendto sock msg 0 (Bytes.length msg) [] client_addr in
      ()

let () =
  (* Read server info from argv *)
  if Array.length Sys.argv < 3 then
    _log Log_Error "rdt.server <addr> <port>"
  else
    let addr, port =
      (inet_addr_of_string Sys.argv.(1), int_of_string Sys.argv.(2))
    in
    (* Create a UDP socket *)
    let sock = socket PF_INET SOCK_DGRAM 0 in
    setsockopt sock SO_REUSEADDR true ;
    let sockaddr = ADDR_INET (addr, port) in
    (* Bind the server's IP address and port number to the socket *)
    bind sock sockaddr ;
    _log Log_Info
      (Printf.sprintf "UDP server listening on %s:%d"
         (string_of_inet_addr addr) port ) ;
    while true do
      send_receive sock sockaddr
    done
