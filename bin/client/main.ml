open Unix
open Rdt.Messages
open Rdt.Logging

let seq_number : int ref = ref 0

let explode s = List.init (String.length s) (String.get s)

let send_receive (sock : file_descr) (sockaddr : sockaddr) : unit =
  print_string ">>> " ;
  let chars = explode (read_line ()) in
  (* Consider one character of data at a time from user input *)
  List.iter
    (fun c ->
      let recvbuf =
        Bytes.create (16 + String.length (string_of_int !seq_number))
      in
      (* Create a DATA message containing the character with the appropriate sequence number *)
      let msg = encode_msg (DATA (!seq_number, c)) in
      let sent = ref false in
      while not !sent do
        (* Send the data message to the server *)
        let _ = sendto sock msg 0 (Bytes.length msg) [] sockaddr in
        _log Log_Info ("Sent sequence " ^ string_of_int !seq_number) ;
        (* Wait for a response from the server *)
        let recvd_correct_ackno = ref false in
        while not !recvd_correct_ackno do
          let ready_socket, _, _ = select [sock] [] [] 5.0 in
          match ready_socket with
          | [] ->
              (* Timed out, no response *)
              recvd_correct_ackno := true ;
              _log Log_Debug
                ("Timed out, resending sequence " ^ string_of_int !seq_number)
          | _ -> (
              (* Ready to read from sock *)
              let _ = recvfrom sock recvbuf 0 (Bytes.length recvbuf) [] in
              (* Parse response *)
              match decode_msg recvbuf with
              | Some (ACK n) when n = !seq_number ->
                  (* If sequence number is correct, increment it and iterate *)
                  seq_number := 1 + !seq_number ;
                  sent := true ;
                  recvd_correct_ackno := true ;
                  _log Log_Info
                    ("Successfully sent sequence " ^ string_of_int !seq_number)
              | _ ->
                  _log Log_Error
                    ( "Did not receive ACK " ^ string_of_int !seq_number
                    ^ ", trying again" ) )
        done
      done )
    chars

let server_addr = "127.0.0.1"

let server_port = 8888

let () =
  (* Create a UDP socket *)
  let sock = socket PF_INET SOCK_DGRAM 0 in
  let sockaddr = ADDR_INET (inet_addr_of_string server_addr, server_port) in
  (* All client logic *)
  while true do
    send_receive sock sockaddr
  done
