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

method !filtragem-lista ($lista) {
#FAZER FILTRAGEM PARA QUE APENAS NÚMEROS INTEIROS PASSEM
	my @retorno = $lista.split(rx{" " || ","}).sort.reverse;
	return @retorno;
}

#######################################################################################
#				MANIPULAÇÃO DE BOLETINS				      #
#######################################################################################

method !boletins-existentes {
#mostra ao usuário uma lista com todos os boletins existentes válidos que
#podem ser manipulados de acordo com a opção escolhida
	my @docs = dir($!endereco-boletins);
	if @docs.elems == 0 { return 0 };
	my @boletins;
	for @docs -> $i { @boletins.push($i.chomp('.txt').split('/')[*-1]) };
	for @boletins -> $i { say  color('green bold'), $i, color('reset') };
	say "";
}

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
	say "Boletins já criados:";
	self!boletins-existentes;
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

#=============================== MANIPULAÇÃO DE BOLETIM ===================================

method !manipula-boletim-alto (Int:D $contador, @lista-manipula) {
	print "Qual ação executar sobre boletim? \n\n";
	loop (my $clk = 0; $clk < @lista-manipula.elems; $clk++) {
		print " " ~ @lista-manipula[$clk] ~ "\t" if $contador!=$clk;
		print ">" ~ color("bold green"), @lista-manipula[$clk], color("reset") ~ "\t" if $contador==$clk;
	}
}

method !manipula-boletim {
#Faz a escolha do tratamento a fazer nos boletins de acordo com o escolhido pelo
#usuário durante a navegação do menu
	ReadMode('cbreak');
	my @lista-manipula = "atirar ", "adicionar  ", "remover";
	my Int $quantidade = @lista-manipula.elems;
	my Int $contador = 0;
	self!manipula-boletim-alto($contador, @lista-manipula);
	my $entrada = ReadKey(0);

	while (True) {
		if (ord($entrada) == 10) { ReadMode('normal'); self!seleciona-manipula($contador); }
		if (ord($entrada) == 68) {
			if ($contador == 0 ) { $contador = $quantidade-1; }
			else { $contador--; }
			};
		if (ord($entrada) == 67) {
			$contador++;
			if ($contador == $quantidade) {$contador = 0; }
			};
		self!manipula-boletim-alto($contador, @lista-manipula);
		$entrada = ReadKey(0);
		shell 'clear';
		}
}

method !atira-alvo {
#Permite que o usuário marque um ou múltiplos alvos em um boletim de
#acordo com os índices por ele fornecido, desde os índices estejam
#abaixo da quantidade existente de alvos e sejam acima de 0
	say "Boletins a serem marcados:";
	self!boletins-existentes;
	my $frase1 = "Boletim a ser marcado:\n>";
	my $frase2 = "Boletim não existente e\nnão pode ser marcado.\n";
	my $boletim-atirado = self!reavaliar-string($frase1, $frase2);
	my $boletim = Boletim.new(:nome-boletim($boletim-atirado));
	my Int $tamanho = $boletim.tamanho;
	$boletim.mostra-boletim;
	my Str $lista = prompt("Alvos a serem marcados:\n>");
	my @lista = self!filtragem-lista($lista);
	for @lista -> $i {
		if ($i <= $tamanho and $i > 0) { $boletim.atira-alvo($i.Int-1); }
		else { next; }
	}
	shell 'clear';
	$boletim.mostra-boletim;
}

method !adiciona-alvo {
#Permite que o usuário adicione um novo alvo a um boletim já existente, desde
#que o novo alvo contenha um texto válido com uma quantidade de caracteres
#diferentes de 0
	say "Boletins que podem ter adição de alvo:";
	self!boletins-existentes;
	my $frase1 = "Boletim a ter adição:\n>";
	my $frase2 = "Boletim não existente e\nnão pode ter adição de alvo\n";
	my $boletim-adicionado = self!reavaliar-string($frase1, $frase2);
	my $boletim = Boletim.new(:nome-boletim($boletim-adicionado));
	my Int $tamanho = $boletim.tamanho;
	$boletim.mostra-boletim;
	my $novo-texto = prompt("Nova a ser adicionada:\n>");
	while $novo-texto.chars == 0 { $novo-texto = prompt("Alvoo não pode ter texto vazio.\n
							     Novo alvo a ser adicionado:\n>") };
	my $alvo = Boletim::Alvo.new(:marcador('-'), :texto($novo-texto));
	$boletim.adiciona-alvo($alvo);
	$boletim.refaz-boletim;
	shell 'clear';
	$boletim.mostra-boletim;
}

method !remove-alvo {
#FAZER CHECAGEM DE TAMANHO DE BOLETIM. CASO ALVOS SEJAM 0 EM VOLUME, APAGAR BOLETIM;
#Permite que o usuário remova um ou mais alvos de um boletim existente, desde
#que o alvo esteja dentro de um limite válido entre um alvo ou mais ou o índice
#esteja abaixo da quantidade de alvos existentes
	say "Remove alvo boletim"; 
	say "Boletins a terem alvos removidos:";
	self!boletins-existentes;
	my $frase1 = "Boletim a ser marcado:\n>";
	my $frase2 = "Boletim não existente e\nnão pode ter alvo removido.\n";
	my $boletim-removido = self!reavaliar-string($frase1, $frase2);
	my $boletim = Boletim.new(:nome-boletim($boletim-removido));
	my Int $tamanho = $boletim.tamanho;
	$boletim.mostra-boletim;
	my Str $lista = prompt("Alvos a serem marcados:\n>");
	my @lista = self!filtragem-lista($lista);
	for @lista -> $i {
		if ($i <= $tamanho and $i > 0) { $boletim.remove-alvo($i.Int-1); }
		else { next; }
	}
	$boletim.refaz-boletim;
	shell 'clear';
	$boletim.mostra-boletim;
}

method !seleciona-manipula (Int:D $entrada) {
#Direcionador para funções de manipulação de boletins, levando para diferentes
#funções que fazem tratamentos dos boletins existentes
	given $entrada {
		shell 'clear';
		when 0  { self!atira-alvo;    exit } #pronto
		when 1  { self!adiciona-alvo; exit } 
		when 2  { self!remove-alvo;   exit } #pronto
		default { "Proteção contra erro interno \n".print; exit;}
	}
}

#============================= VISUALIZAÇÃO DO BOLETIM ====================================

method !visualiza-boletim {
#requer ao usuário um boletim a ser visualizado; caso o boletim exista, mostra o 
#seu conteúdo na tela; caso não exista, informa ao usuário e pede por um nome válido
	say "Boletins a serem visualizados:";
	self!boletins-existentes;
	my $frase1 = "Boletim a ser visualizado:\n>";
	my $frase2 = "Boletim não existente e\nnão pode ser visualizado.\n";
	my $boletim-visualizado = self!reavaliar-string($frase1, $frase2);
	my $boletim = Boletim.new(:nome-boletim($boletim-visualizado));
	shell 'clear';
	$boletim.mostra-boletim;
}

method visualiza-boletim {
#Acesso externo à self!visualiza-boletim para que o usuário possa fazer uso
#pelo menu do programa principal
	self!visualiza-boletim;
}

#================================= REMOÇÃO DE BOLETIM =====================================
method !apaga-boletim { 
#caso um boletim exista, remove o boletim de acordo com o nome especificado
#pelo usuário; caso não exista, avisa ao usuário e pede por um nome válido
	say "Boletins existentes:";
	self!boletins-existentes;
	my $frase1 = "Boletim a ser apagado: \n>";
	my $frase2 = "Boletim não existente e\nnão pode ser apagado.\n";
	my $boletim-apagado = self!reavaliar-string($frase1, $frase2);
	$boletim-apagado.IO.unlink;
	print "\nBoletim apagado.\nTerminando...\n";
}

method remove-boletim { 
#Acesso externo à função de apagar boletins inteiros para ser acessada
#a partir do menu principal do programa
	self!apaga-boletim;
}

#=========================  TROCA DE ALVOS ENTRE BOLETINS ================================

method !troca-alvos-boletim-alto ($boletim1, $boletim2, @lista) {
#Faz a troca entre dois boletins de forma simplificada, servindo como 
#base para self!troca-alvos-boletim para que esse dê opções e faça
#verificações de acordo com o desejado pelo usuário
	if @lista.elems == 0 {
		print "Lista sem entradas inválidas.\nTerminando...\n";
		exit;
	}
	say @lista;
	
	for @lista -> $i {
		if ($i.Int <= 0 or $i.Int > $boletim1.tamanho) { next }
		else {
			$boletim2.adiciona-alvo($boletim1.retorna-alvo($i.Int-1));
			$boletim1.remove-alvo($i.Int-1);
			}
		}
	$boletim1.refaz-boletim;
	$boletim2.refaz-boletim;
}

method !troca-alvos-boletim {
#Faz a troca entre dois boletins dando opções e fazendo verificações de
#acordo com o desejado pelo usuário
	say "Boletins a serem trocados";
	self!boletins-existentes;
	my Str $primeiro    = "Primeiro boletim a trocar alvos:\n>";
	my Str $segundo     = "Segundo boletim a trocar alvos:\n>";
	my Str $inexistente = "Boletim não existe e não pode trocar alvos\n";
	my Str $repetido    = "Boletins não podem conter o mesmo nome\n";
	my $nome-boletim1 = self!reavaliar-string($primeiro, $inexistente);
	my $nome-boletim2 = self!reavaliar-string($segundo,  $inexistente);
	while ($nome-boletim2 eq $nome-boletim1) {	
		print (color('red bold'), "\n[ATENÇÃO]", color('reset'), $repetido);
		$nome-boletim2 = self!valida-nome-boletim("\n" ~ $segundo);
	}
	shell 'clear';
	my $boletim1 = Boletim.new(:nome-boletim($nome-boletim1));
	my $boletim2 = Boletim.new(:nome-boletim($nome-boletim2));
	$boletim1.mostra-boletim(False);
	$boletim2.mostra-boletim(False);
	my int $tamanho1 = $boletim1.elems;
	my Str $indices1 = prompt("Alvos de [{$boletim1.nome-boletim}] a serem trocados:\n>");
	my @indices2 = self!filtragem-lista($indices1);
	self!troca-alvos-boletim-alto($boletim1, $boletim2, @indices2);
	shell 'clear';
	$boletim1.mostra-boletim(False);
	$boletim2.mostra-boletim(False);
}

#=========================== LIMPEZA DE ALVOS DE BOLETINS ================================

method !retorna-lista-txt(@entrada) {
	my @saida;
	for @entrada -> $nome {
		if ($nome.substr($nome.chars-3 .. $nome.chars-1) eq "txt") { @saida.push($nome) };
	}
	return @saida;
}

method !retorna-lista-boletins (@lista) {
	my @saida;
	loop (my $i = 0; $i < @lista.elems; $i++) { 
		my $boletim = Boletim.new(:nome-boletim(@lista[$i]));
		@saida.push($boletim);
	}
	return @saida;
}

method !limpa-boletim-todos {
#Faz uma varredura completa por todos os boletins existentes e limpa os seus alvos
#de forma a não mais conterem nenhuma marcação de checado, caso haja alguma
	shell 'clear';
	print "Limpeza de boletins em curso... \n\n";
	my @arquivos = dir $!endereco-boletins;
	@arquivos = self!retorna-lista-txt(@arquivos);
	my @boletins = self!retorna-lista-boletins(@arquivos);
	for @boletins -> $elemento { $elemento.limpar-boletim; } ;
	print color('bold green'), "\n[!!!] ", color('reset'), "Limpeza concluída\n\n";
	exit;
}

method !limpa-boletim-apenas-um {
#Procura por um boletim específico conforme requerido pelo usuário para que limpe
#as marcações apenas daquele boletim em específico
	shell 'clear';
	say "Boletins que podem ser limpos:";
	self!boletins-existentes;
	my Str $frase1 = "Boletim a ser limpo: \n>";
	my Str $frase2 = "Boletim não existe e não pode ser limpo";
	my $nome-boletim = self!reavaliar-string($frase1, $frase2);
	my $boletim = Boletim.new(:nome-boletim($nome-boletim));
	shell 'clear';
	$boletim.limpar-boletim; say '';
	print color('bold green'), "[!!!] ", color('reset'), "Limpeza concluída\n\n";
	exit;
}

method !printa-menu-limpar (Int:D $entrada, @lista) {
	if ($entrada == 0) { print ">", color('green bold'), "@lista[0]   ",
		             color('reset'), " @lista[1]", "\n" }
	else               { print " ", "@lista[0]   ", ">", color('green bold'), 
	                     "@lista[1]", color('reset'), "\n"}
	my int $contador = 0;
	ReadMode('cbreak');
	my $leitura = ReadKey(0);
	while (True) {
		if (ord($leitura) == 67 or (ord($leitura) == 68)) {
			if $contador == 1 { $contador = 0 }
			else { $contador = 1 }
			if ($contador == 0) { shell 'clear';
					     print ">", color('green bold'), "@lista[0]   ", 
					     color('reset'), " @lista[1]", "\n" }
			else               { shell 'clear';
					     print " ", "@lista[0]   ", ">", color('green bold'), "@lista[1]", 
					     color('reset'), "\n"}
		}
		if (ord($leitura) == 10 ) { 
			ReadMode('normal');
			if ($contador == 0) { self!limpa-boletim-todos     }
			else                { self!limpa-boletim-apenas-um }
		}
		$leitura = ReadKey(0);
	}
}

method !limpa-boletim { self!printa-menu-limpar(0, ["limpar todos", "apenas um"]) }

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
		when 0  { self!cria-boletim;        exit } #pronto
		when 1  { self!manipula-boletim;    exit } #pronto
		when 2  { self!visualiza-boletim;   exit } #pronto
		when 3  { self!apaga-boletim;       exit } #pronto
		when 4  { self!troca-alvos-boletim; exit } #pronto
		when 5  { self!limpa-boletim;       exit } #pronto
		default { "Proteção contra erro interno \n".print; exit;}
	}
}
