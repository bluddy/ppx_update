open Ppxlib
open Ppxlib.Ast_builder.Default

let name = "ppx_update"

(* if b.a == a && b.c == c then b else {b with a; c} *)
let create_test ~loc elist rec_expr =
  let rec loop elist =
    let create_comp ~loc lident comp_exp =
      (eapply ~loc
        (evar ~loc "==") @@
        [pexp_field ~loc rec_expr lident; comp_exp])
    in
    match elist with
    | [lident, e] ->
        create_comp ~loc lident e
    | (lident, e)::rest ->
        eapply ~loc
          (evar ~loc "&&")
          [create_comp ~loc lident e; loop rest]
    | [] -> assert false
  in
  loop elist

let create_record ~loc elist rec_expr =
  pexp_record ~loc elist (Some rec_expr)

let record_extension name =
  Extension.declare name
    Extension.Context.expression
    Ast_pattern.(
      single_expr_payload @@
        pexp_record
          (many __)
          (some __)
      )
    (fun ~loc ~path:_ elist rec_expr ->
      pexp_ifthenelse ~loc
        (create_test ~loc elist rec_expr)
        rec_expr
        (Some (create_record ~loc elist rec_expr)))

let () = Driver.register_transformation  name
  ~rules:
  [
    Context_free.Rule.extension (record_extension "update")
  ]

