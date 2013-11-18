#!/bin/bash

OCAMLC="ocamlfind ocamlc -I src -linkpkg -package ocsfml.graphics"

for f in src/*.mli; do
	$OCAMLC -c $f 
done

for f in src/*.ml; do
	$OCAMLC -c $f 
done

$OCAMLC TeabagGame.cmo test.ml -o test
