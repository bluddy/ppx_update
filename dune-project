(lang dune 3.9)

(name ppx_update)

(version 0.81)

(generate_opam_files true)

(source
 (github bluddy/ppx_update))

(authors "Yotam Barnoy")

(maintainers "yotambarnoy@gmail.com")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name ppx_update)
 (synopsis "PPX library to optimize record updates")
 (description "ppx_update optimizes away record updates when new record contents match old ones")
 (depends ocaml dune ppxlib)
 (tags
  ("ppx")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
