INCLUDES= util,x86,grading,ll
LIBS = unix,str
SUBMIT := lexer.mll parser.mly frontend.ml team.txt

HWNAME := hw04
ZIPNAME := $(HWNAME)-submit.zip


all: main.native

.PHONY: test
test: main.native
	./main.native --test

main.native: $(SUBMIT) ast.ml astlib.ml backend.ml driver.ml main.ml progasts.ml runtime.c 
	ocamlbuild -Is $(INCLUDES) -libs $(LIBS) -pkg num main.native -use-menhir -yaccflag --explain

zip: $(SUBMIT)
	zip '$(ZIPNAME)' $(SUBMIT)

.PHONY: clean
clean:
	ocamlbuild -clean
	rm -rf output a.out


prog: 
	make clean
	make
	./main.native --print-oat --print-ast --print-ll --clang --execute-x86 oatprograms/run23.oat

glob: 
	make clean
	make
	./main.native --print-ast --print-oat --print-ll --execute-x86 oatprograms/globals5.oat

diego: 
	make clean
	make
	./main.native --print-ast --print-oat --print-ll --clang --execute-x86 oatprograms/runDiego.oat
