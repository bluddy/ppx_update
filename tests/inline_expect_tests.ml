type t = { a : int; b : int; mutable x : int }

let%expect_test "rhs evaluated once" =
  let r = ref 0 in
  let v = { a = 0; b = 0; x = 0 } in
  let _ = [%up { v with a = (incr r; 1); b = (incr r; 2) }] in
  Printf.printf "%d\n" !r;
  [%expect {| 2 |}] 

let%expect_test "setfield single eval" =
  let r = ref 0 in
  let obj = { a = 0; b = 0; x = 0 } in
  [%upf obj.x <- (incr r; 5)];
  Printf.printf "%d\n" !r;
  [%expect {| 1 |}]