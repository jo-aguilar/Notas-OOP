#!/bin/env perl6

unit class Boletim;

class Alvo {
	has Str $!marcador;
	has Str $!texto;

	method faz-marcador ($marcador) { $!marcador = $marcador; };
	method faz-texto    ($texto   ) { $!texto = $texto; };
}

has @!alvos;
has $teste = "teste";

method mostra-teste { say "isso é um $teste"; }
