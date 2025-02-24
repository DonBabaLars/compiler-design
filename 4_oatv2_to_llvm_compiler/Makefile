INCLUDES= util,x86,grading,ll
LIBS = unix,str
SUBMIT := frontend.ml typechecker.ml team.txt

HWNAME := hw05
ZIPNAME := $(HWNAME)-submit.zip


all: main.native

.PHONY: test
test: main.native
	./main.native --test

.PHONY: main.native
main.native: 
	ocamlbuild -pkg num -Is $(INCLUDES) -libs $(LIBS) main.native -use-menhir -yaccflag --explain

zip: $(SUBMIT)
	zip '$(ZIPNAME)' $(SUBMIT)

.PHONY: clean
clean:
	ocamlbuild -clean
	rm -rf output a.out

diego: 
	make clean
	make
	./main.native --print-ll --clang --execute-x86 oatprograms/count_sort.oat

mydiego: 
	make clean
	make
	./main.native --print-ll --execute-x86 --clang programs/tc1.oat

lars: 
	make clean
	make
	./main.native --print-ll --clang --execute-x86 hw5programs/compile_assign_struct.oat

lars2: 
	make cleanocam
	make
	./main.native --print-ll --clang --execute-x86 hw5programs/compile_global_struct_fptr.oat