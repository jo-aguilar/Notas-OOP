#!/bin/env perl6

unit class Boletim;

class Alvo {
	has Str $!marcador;
	has Str $!texto;
	
	submethod BUILD (:$marcador, :$texto) {
		$!marcador = $marcador;
		$!texto = $texto;
	}
	method marcador { return $!marcador }
	method texto    { return $!texto    }
}

has @!alvos;
has $!nome-boletim;

method !preenche-boletim {
	my @entradas-boletim;
	for $!nome-boletim.IO.lines -> $linhas {
		@entradas-boletim.push($linhas);
	}
	
	loop (my $i = 0; $i < @entradas-boletim.elems; $i+=2) {
		@!alvos.push(Alvo.new(:marcador(@entradas-boletim[$i]), 
				      :texto(@entradas-boletim[$i+1])));
	}
}

method mostra-boletim {
	shell 'clear';
	my $nome = $!nome-boletim.chomp(".txt").split("/");
	print color('green bold'), "[" ~ $nome[*-1] ~ "]\n", color('reset') ~ "\n" ;
	use Terminal::ANSIColor;
	self!preenche-boletim;
	for @!alvos -> $alvo {
		my $marcador = $alvo.marcador eq "-"??" "!!"*";
		print("#{++$_}: [",
		      color('green bold'),$marcador, color('reset'), "]",
		      $alvo.texto ~ "\n");
	}
}

submethod BUILD (:$nome-boletim) { 
	$!nome-boletim = $nome-boletim; 
}

