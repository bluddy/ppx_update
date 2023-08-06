
type a = {
  x: int;
} [@@deriving show]

type d = {
  y: int;
} [@@deriving show]

type b = {
  a: a;
  d: d;
  foo: int;
} [@@deriving show]

let () =
  let a = {x=3} in
  let d = {y=1} in

  let b = {a=a; d=d; foo=10} in
  let b2 = [%update {b with a; d}] in
  print_string @@ show_b b2
  


