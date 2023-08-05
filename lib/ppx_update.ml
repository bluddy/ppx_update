open Ppxlib

let name = "ppx_update"

let record_extension name =
  Extension.declare name
    Extension.Context.expression
    Ast_pattern.(
      single_expr_payload @@
        pexp_record
          (many __)
          (some __)
      )
    (fun ~loc:_ ~path:_ _a b -> b)

let () = Driver.register_transformation  name
  ~rules:
  [
    Context_free.Rule.extension (record_extension "update")
  ]

