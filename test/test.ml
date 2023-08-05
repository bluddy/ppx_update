
type a = {
  x: int;
} [@@deriving show]

type b = {
  a: a;
  foo: int;
} [@@deriving show]

let () =
  let a = {x=3} in
  (* let a2 = {x=5} in *)

  let b = {a=a; foo=10} in
  let b2 = [%update {b with a}] in
  print_string @@ show_b b2
  


