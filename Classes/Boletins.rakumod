#!/bin/env perl6

unit class Boletins;
use strict;
use Terminal::ANSIColor;
use Adverb::Eject;
use Boletim;
use Term::ReadKey:from<Perl5>;
#ReadMode('cbreak');

has @!lista-boletim = "Criar", "Manipular", "Visualizar", "Apagar", "Trocar alvos", "Limpar";
has $!endereco-boletins = $*HOME ~ "/Documents/Notas/Boletins/".IO;

method mostra-ajuda { say "Mostrando ajuda"; }

#######################################################################################
#				MANIPULAÇÃO DE BOLETINS				      #
#######################################################################################

#`(method !retorna-cond2 () {*}

#method !valida-nome-boletim {
	#my $nome-boletim = prompt ("Nome do boletim a ser criado: \n>");
	#$nome-boletim  = ($!endereco-boletins ~ $nome-boletim ~ ".txt").IO;
	#return $nome-boletim;) 
#	*
#}

method !checa-entrada-alvo (Str:D $entrada) {
	#verifica se a entrada não é nula ou inválida como alvo
	*
}

method !preenche-arquivo-boletim($nome-boletim, @lista-boletim) {
	#spurt $nome-boletim, @lista-boletim[0] ~ "\n";
	#for 1..@lista-boletim.elems -> $i { spurt $nome-boletim, $i ~ "\n", :append; }
	*
}

method !adiciona-alvos-boletim (Str:D $nome-boletim) {
	#shell 'clear';	
	#say q:to/END/;
	#	Entre com alvos a serem adicionados, e então [ENTER]
	#	Para terminar a lista aperte [q] e então [ENTER]
	#	END
		
	#my @lista-boletim;
	#my Str $entrada = '';
	#while ($entrada ne 'q') {
	#	if ($entrada eq 'q') { last };
	#	$entrada = prompt("\n>");
	#	#$entrada = self!checa-entrada-alvo($entrada);
	#	@lista-boletim.push($entrada);
	#}
	#say @lista-boletim;
	*
}

method !cria-boletim () {
	#print "Criando Boletim\n";
	#my $nome-boletim = self!valida-nome-boletim;
	#while ($nome-boletim.e) {
	#	#Boletim não pôde ser criado por já existir
	#	print color('red bold'), "\n[ATENÇÃO]", color('reset'), " Boletim já existente.\n";
	#	$nome-boletim = self!valida-nome-boletim;
	#	}
	##Boletim é criado para futuras adições de alvos
	#spurt $nome-boletim.Str, '';
	#self!adiciona-alvos-boletim($nome-boletim.Str);
	*
}

method !manipula-boletim ()   { print "Manipulando Boletim\n"; exit  }
method !visualiza-boletim ()  { print "Visualizando Boletim\n"; exit }
method !apaga-boletim ()      { print "Apagando Boletim\n"; exit     }
method !troca-alvos-boletim() { print "Trocando Boletim\n"; exit     } 
method !limpa-boletim ()      { print "Limpando Boletins\n"; exit    }

method !seleciona-menu (Int:D $entrada) {
#Direcionador para funções de manipulação de boletins, levando para diferentes
#funções que fazem tratamentos dos boletins existentes
	#given $entrada {
	#	shell 'clear';
	#	when 0  { print self!cria-boletim();      exit }
	#	when 1  { print self!manipula-boletim;    exit }
	#	when 2  { print self!visualiza-boletim;   exit }
	#	when 3  { print self!apaga-boletim;       exit }
	#	when 4  { print self!troca-alvos-boletim; exit }
	#	when 5  { print self!limpa-boletim;       exit }
	#	default { "Proteção contra erro interno \n".print; exit;}
	#}
}

method !menu-boletim-alto (Int:D $contador) { 
	#print "Qual ação executar sobre boletim? \n\n";
	#loop (my $clk = 0; $clk < @!lista-boletim.elems; $clk++) {
	#	say " " ~ @!lista-boletim[$clk] if $contador!=$clk;
	#	say ">" ~ color("bold green"), @!lista-boletim[$clk], color("reset") if $contador==$clk;
	#}
}

method menu-boletim {
#Faz a escolha do tratamento a fazer nos boletins de acordo com o escolhido pelo
#usuário durante a navegação do menu
	#ReadMode('cbreak');
	#my Int $quantidade = @!lista-boletim.elems;
	#my Int $contador = 0;
	#self!menu-boletim-alto($contador);
	#my $entrada = ReadKey(0);

	#while (True) {
	#	if (ord($entrada) == 10) { self!seleciona-menu($contador); }
	#	if (ord($entrada) == 66) {
	#		if ($contador == $quantidade-1 ) { $contador-= $quantidade -1; }
	#		else { $contador++; }
	#		};
	#	if (ord($entrada) == 65) {
	#		$contador--;
	#		if ($contador == -1) {$contador = $quantidade -1; }
	#		};
	#	self!menu-boletim-alto($contador);
	#	$entrada = ReadKey(0);
	#	shell 'clear';
	#	}
	*
}

method erro-comando { say "Comando errado"; }

method remove-boletim { say "Removendo boletim"; }

method visualiza-boletim { say "Visualizando boletim"; }
