# ppx_update

`ppx_update` is a small utility ppx for optimizing record updates with certain patterns.

A pattern one comes across when writing certain kinds of OCaml programs is:

```ocaml
type a = {...}
type b = {...}
type c = {a:a; b:b; ...}

let update c =
  let a' = ... in
  let b' = ... in
  {c with a'; b'; ... }
```

Now, if `a'` and `b'` are the same as `c`'s previous values `a` and `b`, what we want to do for efficiency is this:

```ocaml
let update c =
  let a' = ... in
  let b' = ... in
  if c.a == a' && c.b == b' then
     c
  else
    {c with a'; b'; ... }
```

Physical equality is a very quick check that helps us avoid allocation when it's not needed.
`ppx_update` lets you do this more easily:

```ocaml
let update c =
  let a' = ... in
  let b' = ... in
  [%up {c with a'; b'; ... }] (* will automatically take care of comparisons *)
```

Similarly, if `b` is mutable:

```ocaml
type a = {...}
type c = {mutable a:a; ...}

let update c =
  let b' = ... in
  c.b <- b'
```

In this case, we want to try and avoid the write barrier in case `b' == b`, which we can check for with

```ocaml
let update c =
  let b' = ... in
  if c.b == b' then
    ()
  else 
    c.b <- b'
```

With `ppx_update`:

```ocaml
let update c =
  let b' = ... in
  [%upf c.b <- b']  (* will only update if there's no physical address match *)
```

## Using with dune

Simply add to your preprocessing sections in dune
```
; In your library or executable section
  (libraries ppx_update)
  (preprocess (ppx ppx_update))
```

## Commands

Only two extensions are currently supported:

* `%up` (for `update`): handles record update.
Will only work if you have a record that is functionally updated using the `with` keyword.
* `%upf` (for `update_field`): handles mutable field updates.

Note that `ppx_update` is simple, so if you update with a long expression, that expression will be computed twice.
For example, this is good:

```ocaml
c.foo <- foo';
```

but this is not a good idea:
```ocaml
c.foo <- long_computation a b c;
```

since the long computation will be performed twice.
