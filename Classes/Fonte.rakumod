#!/bin/env perl6

unit class Fonte;
use Terminal::ANSIColor;
use Adverb::Eject;

has Str $!arquivo-notas = $*HOME.Str ~ "/Documents/Notas/notas.txt";

method mostra-ajuda { say "Mostrando ajuda"; }

#######################################################################################
#  				MANIPULAÇÃO DE NOTAS                                  #
#######################################################################################

method adiciona-nota {
	{ print "Arquivo de notas inexistente.\nCriando...\n\n";
	  spurt $!arquivo-notas.IO;
		} if !$!arquivo-notas.IO.e;
	my $nova-nota = prompt("Nota: \n>");
	$nova-nota ~= "\n";
	spurt $!arquivo-notas, $nova-nota, :append;
}

method visualiza-notas {
	say color("bold yellow"), "[NOTAS]", color('reset'); 
	for $!arquivo-notas.IO.lines -> $linhas { say "#" ~ ++$_ ~ ": " ~ $linhas; }
	print "\n";
}

method refaz-notas (@array-notas) {
	spurt $!arquivo-notas.IO;
	for @array-notas -> $linhas { 
		spurt $!arquivo-notas.IO, $linhas ~ "\n" , :append; 
		}
}

method remove-nota {
	self.visualiza-notas;
	my @array-notas = $!arquivo-notas.IO.lines;
	my Int $numero-da-nota = -1;
	
	while ($numero-da-nota.Int>@array-notas.elems or 
	       $numero-da-nota == '' or $! or 
	       $numero-da-nota==-1) { 			
		if ($numero-da-nota.Int>@array-notas.elems) {
			say color('red'), "[ERRO]", color('reset'), 
				" Nota inexistente\n";
			$numero-da-nota = -1;
			}
		elsif ($numero-da-nota=='') { 
			say color('red'), "[ERRO]", color('reset'), 
				" Entradas em branco não aceitas\n";
			}
		elsif ($!) {
			say color('red'), "[ERRO]", color('reset'),
				" Apenas valores numéricos aceitos\n" if $!;	
			};
		try { $numero-da-nota = prompt("Nota a ser removida: \n>"); }
		} 
	@array-notas[$numero-da-nota - 1]:eject;
	self.refaz-notas(@array-notas);
	shell 'clear';
	self.visualiza-notas;
	print "Nota removida\n";
}

#######################################################################################
#				MANIPULAÇÃO DE BOLETINS				      #
#######################################################################################

method menu-boletim { say "Menu do boletim"; }

method erro-comando { say "Comando errado"; }

method remove-boletim { say "Removendo boletim"; }

method visualiza-boletim { say "Visualizando boletim"; }


















