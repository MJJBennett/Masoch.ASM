all: interpreter

.PHONY: clean interpreter all debug stage_2.o stage_2_debug.o

stage_2.o:
	nasm -f macho64 interpreter.asm -o stage_2.o

interpreter: stage_2.o
	gcc -o output stage_2.o

stage_2_debug.o:
	# This is where things get interesting
	clang -g -c -x assembler interpreter.asm -o stage_2_debug.o

debug: stage_2_debug.o
	clang stage_2_debug.o debug.out	

clean: 
	@rm *.o output || true
