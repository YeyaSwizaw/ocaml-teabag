#!/bin/bash

OCAMLC="ocamlfind ocamlc -I src -linkpkg -package ocsfml.graphics"

for f in src/Teabag{Global,Map,Game}.mli; do
	$OCAMLC -c $f 
done

for f in src/Teabag{Global,Map,Game}.ml; do
	$OCAMLC -c $f 
done

$OCAMLC str.cma TeabagGlobal.cmo TeabagMap.cmo TeabagGame.cmo test.ml -o test
