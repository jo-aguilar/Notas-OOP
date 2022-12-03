#!/bin/env perl6

unit class Notas;
use Terminal::ANSIColor;
use Adverb::Eject;

has Str $!arquivo-notas = $*HOME.Str ~ "/Documents/Notas/notas.txt";
method mostra-ajuda { say "Mostrando ajuda"; }

#######################################################################################
#  				MANIPULAÇÃO DE NOTAS                                  #
#######################################################################################

method adiciona-nota {
#Adiciona uma nova nota ao arquivo de notas no diretório dedicado.
#Caso o arquivo não exista, cria um e então adiciona a nota
	{ print "Arquivo de notas inexistente.\nCriando...\n\n";
	  spurt $!arquivo-notas.IO;
		} if !$!arquivo-notas.IO.e;
	my $nova-nota = prompt("Nota: \n>");
	$nova-nota ~= "\n";
	spurt $!arquivo-notas, $nova-nota, :append;
}

method visualiza-notas {
#Mostra as notas já existentes em um arquivo de notas
#Caso o arquivo devolva 0 linhas, diz que não há notas a serem mostradas
	if ($!arquivo-notas.IO.lines.elems == 0) {
		print(color('red bold'), "[ATENÇÃO]", color('reset'), 
		" Não há notas a serem mostradas.\nTerminando...\n");
		exit;
		}
	say color("bold yellow"), "[NOTAS]", color('reset'); 
	for $!arquivo-notas.IO.lines -> $linhas { say "#" ~ ++$_ ~ ": " ~ $linhas; }
	print "\n";
}

method !refaz-notas (@array-notas) {
#Refaz o arquivo de notas de acordo com a quantidade existente de notas
#tendo o usuário removido uma delas
	spurt $!arquivo-notas.IO;
	for @array-notas -> $linhas { 
		spurt $!arquivo-notas.IO, $linhas ~ "\n" , :append; 
		}
}

method !retorna-cond1 ($numero-da-nota, @array-notas) {
#Retorna True caso as condições para a remoção de uma nota sejam válidas
#de acordo com a lógica do programa e quantidade de notas existentes
	return any($numero-da-nota.Int>@array-notas.elems,
		   $numero-da-nota=='',
		   $numero-da-nota==-1).Bool;
}

method !remove-nota-alto ($numero-da-nota, @array-notas){
# =======================>FAZER!!!! Fazer um tratamento para que 
#um número das notas não possa ser negativo
	my Bool $cond = self!retorna-cond1($numero-da-nota, @array-notas);
	my Int  $num2;
			
	while ($cond==True) { 			
		if ($numero-da-nota.Int>@array-notas.elems) { say color('red'), "[ERRO]", color('reset'),							" Nota inexistente\n";
			$numero-da-nota = -1; }
		elsif ($numero-da-nota=='') { say color('red'), "[ERRO]", color('reset'), 
					    " Entradas em branco não aceitas\n"; }
		elsif ($!) { say color('red'), "[ERRO]", color('reset'), 
					    " Apenas valores numéricos aceitos\n" if $!; };
		try { $num2 = prompt("Nota a ser removida: \n>"); }
		$cond = self!retorna-cond1($num2, @array-notas);
		}
	return $num2;
}

method remove-nota {
#Remove uma nota de acordo com o especificado com um valor de índice
#especificado com o usuário
	self.visualiza-notas;
	my @array-notas = $!arquivo-notas.IO.lines;
	my Int $numero-da-nota = -1;
	$numero-da-nota = self!remove-nota-alto($numero-da-nota, @array-notas);
	@array-notas[$numero-da-nota - 1]:eject;
	self!refaz-notas(@array-notas);
	shell 'clear';
	self.visualiza-notas;
	print "Nota removida\n";
}

