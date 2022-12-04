#!/bin/env perl6

unit class Boletins;
use strict;
use Terminal::ANSIColor;
use Adverb::Eject;
use Boletim;
use Term::ReadKey:from<Perl5>;

has @!lista-boletim = "Criar", "Manipular", "Visualizar", "Apagar", "Trocar alvos", "Limpar";
has $!endereco-boletins = $*HOME ~ "/Documents/Notas/Boletins/".IO;

method mostra-ajuda { say "Mostrando ajuda"; }
method erro-comando { say "Comando errado"; }

method !reavaliar-string (Str:D $frase1, Str:D $frase2) {
#pega uma string do usuário e verifica se é um path válido para um
#arquivo de boletim; caso não seja, continua pedindo ao usuário que
#entre com um nome válido
	my $boletim = self!valida-nome-boletim($frase1);
	my $flag = False;
	while ($flag == False) {
		if (!$boletim.e) {
		print (color('red bold'), "\n[ATENÇÃO]", color('reset'), $frase2);
			$boletim = self!valida-nome-boletim("\n" ~ $frase1);
		}
		else { return $boletim; }
	}
}

#######################################################################################
#				MANIPULAÇÃO DE BOLETINS				      #
#######################################################################################

method !retorna-cond2 () {*}

method !valida-nome-boletim (Str:D $frase = "Nome do boletim a ser criado: \n>") {
#cria e retorna o boletim com um nome válido de um path a ser utilizado
#pelo programa para armazenar o arquivo na pasta de boletins
	if ($frase eq "q") {
		print "\nTerminando...\n";
		exit;
	}
	my $nome-boletim = prompt ($frase);
	$nome-boletim  = ($!endereco-boletins ~ $nome-boletim ~ ".txt").IO;
	return $nome-boletim;
}

method !checa-entrada-alvo (Str:D $entrada) {
	#verifica se a entrada não é nula ou inválida como alvo
}

#================================= CRIAÇÃO DE BOLETIM =================================
method !preenche-arquivo-boletim($nome-boletim, @lista-boletim) {
#método suporte de criação de um arquivo vazio para que ser utilizado posteriormente
#para o preenchimento com os alvos fornecidos pelo usuário
	spurt $nome-boletim, @lista-boletim[0] ~ "\n";
	for 1..@lista-boletim.elems -> $i { spurt $nome-boletim, $i ~ "\n", :append; }
}

method !cria-documento-boletim (Str:D $nome-boletim, @lista-boletim) {
#cria um documento com todos os alvos e seus status "não atirados" em um
#arquivo de extensão .txt para armazenar o que foi fornecido pelo usuário
	spurt $nome-boletim, "-\n" ~ @lista-boletim[0] ~ "\n";
	loop (my $i = 1; $i < @lista-boletim.elems; $i++){
		spurt $nome-boletim, "-\n", :append;
		spurt $nome-boletim, @lista-boletim[$i] ~ "\n", :append;
	}
}

method !adiciona-alvos-boletim (Str:D $nome-boletim) {
#abre um loop para que o usuário adicione alvos a um boletim até que ele
#decida terminar o boletim utilizando [q] + [ENTER]
	shell 'clear';	
	say q:to/END/;
		Entre com alvos a serem adicionados, e então [ENTER]
		Para terminar a lista aperte [q] e então [ENTER]
		END
		
	print "\n";
	my @lista-boletim;
	my Str $entrada = '';
	while ($entrada ne 'q') {
		if ($entrada eq 'q') { last };
		$entrada = prompt(">");
		#$entrada = self!checa-entrada-alvo($entrada);
		@lista-boletim.push($entrada);
	}
	@lista-boletim = @lista-boletim[0..@lista-boletim-2];
	self!cria-documento-boletim($nome-boletim, @lista-boletim);
}

method !cria-boletim {
#Cria um boletim a partir do nome especificado pelo usuário e pela lista
#de elementos fornecida por ele como alvos do boletim a ser utilizado
	my $frase1 = "Boletim a ser criado:\n>";
	my $frase2 = "Boletim já existente.\n";
	my $nome-boletim = self!valida-nome-boletim;
	while ($nome-boletim.e) {
		#Boletim não pôde ser criado por já existir
		print color('red bold'), "\n[ATENÇÃO]", color('reset'), " Boletim já existente.\n";
		$nome-boletim = self!valida-nome-boletim;
		}
	#Boletim é criado para futuras adições de alvos
	spurt $nome-boletim.Str, '';
	self!adiciona-alvos-boletim($nome-boletim.Str);
	print "\nBoletim criado.\nTerminando...\n";
}

#=================================> NÃO FEITO <=======================================
method !manipula-boletim ()   { print "Manipulando Boletim\n"; exit  }
#=================================> NÃO FEITO <=======================================



#============================= VISUALIZAÇÃO DO BOLETIM ====================================

method !visualiza-boletim {
#requer ao usuário um boletim a ser visualizado; caso o boletim exista, mostra o 
#seu conteúdo na tela; caso não exista, informa ao usuário e pede por um nome válido
	my $frase1 = "Boletim a ser visualizado:\n>";
	my $frase2 = "Boletim não existente e\nnão pode ser visualizado.\n";
	my $boletim-visualizado = self!reavaliar-string($frase1, $frase2);
	my $boletim = Boletim.new(:nome-boletim($boletim-visualizado));
	$boletim.mostra-boletim;
}

#================================= REMOÇÃO DE BOLETIM =====================================
method !apaga-boletim { 
#caso um boletim exista, remove o boletim de acordo com o nome especificado
#pelo usuário; caso não exista, avisa ao usuário e pede por um nome válido
	my $frase1 = "Boletim a ser apagado: \n>";
	my $frase2 = "Boletim não existente e\nnão pode ser apagado.\n";
	my $boletim-apagado = self!reavaliar-string($frase1, $frase2);
	$boletim-apagado.IO.unlink;
	print "\nBoletim apagado.\nTerminando...\n";
}

#=========================  TROCA DE ALVOS ENTRE BOLETINS ================================
method !troca-alvos-boletim() { print "Trocando Boletim\n"; exit     } 

#=========================== LIMPEZA DE ALVOS DE BOLETINS ================================
method !limpa-boletim ()      { print "Limpando Boletins\n"; exit    }

#=================================== MENU PRINCIPAL ========================================
method !menu-boletim-alto (Int:D $contador) { 
	print "Qual ação executar sobre boletim? \n\n";
	loop (my $clk = 0; $clk < @!lista-boletim.elems; $clk++) {
		say " " ~ @!lista-boletim[$clk] if $contador!=$clk;
		say ">" ~ color("bold green"), @!lista-boletim[$clk], color("reset") if $contador==$clk;
	}
}

method menu-boletim {
#Faz a escolha do tratamento a fazer nos boletins de acordo com o escolhido pelo
#usuário durante a navegação do menu
	ReadMode('cbreak');
	my Int $quantidade = @!lista-boletim.elems;
	my Int $contador = 0;
	self!menu-boletim-alto($contador);
	my $entrada = ReadKey(0);

	while (True) {
		if (ord($entrada) == 10) { ReadMode('normal'); self!seleciona-menu($contador);}
		if (ord($entrada) == 66) {
			if ($contador == $quantidade-1 ) { $contador-= $quantidade -1; }
			else { $contador++; }
			};
		if (ord($entrada) == 65) {
			$contador--;
			if ($contador == -1) {$contador = $quantidade -1; }
			};
		self!menu-boletim-alto($contador);
		$entrada = ReadKey(0);
		shell 'clear';
		}
}


method !seleciona-menu (Int:D $entrada) {
#Direcionador para funções de manipulação de boletins, levando para diferentes
#funções que fazem tratamentos dos boletins existentes
	given $entrada {
		shell 'clear';
		when 0  { self!cria-boletim;        exit }
		when 1  { self!manipula-boletim;    exit }
		when 2  { self!visualiza-boletim;   exit }
		when 3  { self!apaga-boletim;       exit }
		when 4  { self!troca-alvos-boletim; exit }
		when 5  { self!limpa-boletim;       exit }
		default { "Proteção contra erro interno \n".print; exit;}
	}
}
