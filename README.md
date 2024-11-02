# RDT\_OCaml

An implementation of a Reliable Data Transfer (RDT) protocol in OCaml over UDP.

[rdt3.0 - stop-and-wait](https://www.geeksforgeeks.org/reliable-data-transfer-rdt-3-0/)

## Example

### Client

```
$ make runclient
dune build
dune exec -- rdt.client 10.176.69.129 8888
>>> Hello World!                    
LOG:[INFO] - Sent sequence 0
LOG:[DEBUG] - Decode result: ACK 0
LOG:[INFO] - Successfully sent sequence 1
LOG:[INFO] - Sent sequence 1
LOG:[DEBUG] - Decode result: ACK 1
LOG:[INFO] - Successfully sent sequence 2
LOG:[INFO] - Sent sequence 2
LOG:[DEBUG] - Decode result: ACK 2
LOG:[INFO] - Successfully sent sequence 3
LOG:[INFO] - Sent sequence 3
LOG:[DEBUG] - Decode result: ACK 3
LOG:[INFO] - Successfully sent sequence 4
LOG:[INFO] - Sent sequence 4
LOG:[DEBUG] - Decode result: ACK 4
LOG:[INFO] - Successfully sent sequence 5
LOG:[INFO] - Sent sequence 5
LOG:[DEBUG] - Decode result: ACK 5
LOG:[INFO] - Successfully sent sequence 6
LOG:[INFO] - Sent sequence 6
LOG:[DEBUG] - Decode result: ACK 6
LOG:[INFO] - Successfully sent sequence 7
LOG:[INFO] - Sent sequence 7
LOG:[DEBUG] - Decode result: ACK 7
LOG:[INFO] - Successfully sent sequence 8
LOG:[INFO] - Sent sequence 8
LOG:[DEBUG] - Decode result: ACK 8
LOG:[INFO] - Successfully sent sequence 9
LOG:[INFO] - Sent sequence 9
LOG:[DEBUG] - Decode result: ACK 9
LOG:[INFO] - Successfully sent sequence 10
LOG:[INFO] - Sent sequence 10
LOG:[DEBUG] - Decode result: ACK 10
LOG:[INFO] - Successfully sent sequence 11
LOG:[INFO] - Sent sequence 11
LOG:[DEBUG] - Decode result: ACK 11
LOG:[INFO] - Successfully sent sequence 12
>>> Wow!
LOG:[INFO] - Sent sequence 12
LOG:[DEBUG] - Decode result: ACK 12
LOG:[INFO] - Successfully sent sequence 13
LOG:[INFO] - Sent sequence 13
LOG:[DEBUG] - Decode result: ACK 13
LOG:[INFO] - Successfully sent sequence 14
LOG:[INFO] - Sent sequence 14
LOG:[DEBUG] - Decode result: ACK 14
LOG:[INFO] - Successfully sent sequence 15
LOG:[INFO] - Sent sequence 15
LOG:[DEBUG] - Decode result: ACK 15
LOG:[INFO] - Successfully sent sequence 16
```

### Server

``` bash
$ make runserver
dune build
dune exec -- rdt.server 0.0.0.0 8888
LOG:[INFO] - UDP server listening on 0.0.0.0:8888
LOG:[DEBUG] - Decode result: DATA 0 H
LOG:[INFO] - Received: H
LOG:[DEBUG] - Decode result: DATA 1 e
LOG:[INFO] - Received: e
LOG:[DEBUG] - Decode result: DATA 2 l
LOG:[INFO] - Received: l
LOG:[DEBUG] - Decode result: DATA 3 l
LOG:[INFO] - Received: l
LOG:[DEBUG] - Decode result: DATA 4 o
LOG:[INFO] - Received: o
LOG:[ERROR] - Tried to decode unrecognized message: DATA 5  
LOG:[DEBUG] - Decode result: DATA 6 W
LOG:[INFO] - Received: W
LOG:[DEBUG] - Decode result: DATA 7 o
LOG:[INFO] - Received: o
LOG:[DEBUG] - Decode result: DATA 8 r
LOG:[INFO] - Received: r
LOG:[DEBUG] - Decode result: DATA 9 l
LOG:[INFO] - Received: l
LOG:[DEBUG] - Decode result: DATA 10 d
LOG:[INFO] - Received: d
LOG:[DEBUG] - Decode result: DATA 11 !
LOG:[INFO] - Received: !
LOG:[DEBUG] - Decode result: DATA 12 W
LOG:[INFO] - Received: W
LOG:[DEBUG] - Decode result: DATA 13 o
LOG:[INFO] - Received: o
LOG:[DEBUG] - Decode result: DATA 14 w
LOG:[INFO] - Received: w
LOG:[DEBUG] - Decode result: DATA 15 !
LOG:[INFO] - Received: !
```
