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
  | _ ->
      (* Malformed data received *)
      (* Send a duplicate ACK to the client *)
      let msg = encode_msg (ACK !seq_number) in
      let _ = sendto sock msg 0 (Bytes.length msg) [] client_addr in
      ()

let server_addr = "127.0.0.1"

let server_port = 8888

let () =
  (* Create a UDP socket *)
  let sock = socket PF_INET SOCK_DGRAM 0 in
  setsockopt sock SO_REUSEADDR true ;
  let sockaddr = ADDR_INET (inet_addr_of_string server_addr, server_port) in
  (* Bind the server's IP address and port number to the socket *)
  bind sock sockaddr ;
  Printf.printf "UDP server listening on %s:%d\n" server_addr server_port ;
  while true do
    send_receive sock sockaddr
  done
