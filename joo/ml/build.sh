rm -rf bin
mkdir bin
rm -f *.c* ../js/main.js
ocamlfind ocamlc -package js_of_ocaml -package js_of_ocaml.syntax -syntax camlp4o -linkpkg -o bin/main.byte main.ml 
js_of_ocaml -o ../js/main.js bin/main.byte 
rm -f *.c*
