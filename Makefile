CC=g++
AC=Fonte.cpp
AO=Fonte.o
AT=notas.cpp


all: compila

compila:
	$(CC) -c $(AC) -o $(AO)
	ar rcs libFonte.a $(AO)

teste:
	$(CC) -static $(AT) -L. -lFonte -lBoletim -lAlvo -o notas
	./notas

limpa:
	rm notas Fonte.o libFonte.a
