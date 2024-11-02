(lang dune 3.9)

(name RDT_OCaml)

(generate_opam_files true)

(source
 (github CharlesAverill/RDT_OCaml))

(authors "Charles Averill")

(maintainers "Charles Averill")

(license LICENSE)

(documentation https://github.com/CharlesAverill/RDT_OCaml)

(package
 (name RDT_OCaml)
 (synopsis "")
 (description "An implementation of a Reliable Data Transfer (RDT) protocol in OCaml over UDP")
 (depends ocaml dune alcotest ocamlformat))

