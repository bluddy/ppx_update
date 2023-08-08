
type a = {
  _x: int;
}

type d = {
  _y: int;
}

type b = {
  a: a;
  mutable d: d;
  _foo: int;
}

let () =
  let a = {_x=3} in
  let d = {_y=1} in

  let b = {a=a; d=d; _foo=10} in
  let b2 = [%up {b with a; d}] in
  Printf.printf "Update with the same members: same=%b\n" (b2 == b);
  let b3 = [%up {b with a={_x=5}}] in
  Printf.printf "Update with different members: same=%b\n" (b3 == b);

  print_endline "---- Record update ----";
  let t = Sys.time () in
  let d2 = d in
  for _=0 to 100000 do
    [%upf b2.d <- d];
    [%upf b2.d <- d2];
  done;
  let delta1 = Sys.time () -. t in

  let t = Sys.time () in
  let d2 = {_y=2} in
  for _=0 to 100000 do
    [%upf b2.d <- d2];
    [%upf b2.d <- d];
  done;
  let delta2 = Sys.time () -. t in
  Printf.printf "Record update different item takes more time:%b\n" (delta2 > delta1);
  ()

  


