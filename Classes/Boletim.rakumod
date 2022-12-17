#!/bin/env perl6

unit class Boletim;

class Alvo {
	has Str $!marcador;
	has Str $!texto;
	
	submethod BUILD (:$marcador, :$texto) {
		$!marcador = $marcador;
		$!texto = $texto;
	}
	method marcador is rw { $!marcador; }
	method texto    is rw { $!texto;    }
}

has @!alvos;
has $!nome-boletim;

submethod BUILD (:$nome-boletim) { 
	$!nome-boletim = $nome-boletim; 
}

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
	use Terminal::ANSIColor;
	shell 'clear';
	my $nome = $!nome-boletim.chomp(".txt").split("/");
	print color('green bold'), "[" ~ $nome[*-1] ~ "]\n", color('reset') ~ "\n" ;
	self!preenche-boletim;
	for @!alvos -> $alvo {
		my $marcador = $alvo.marcador eq "-"??" "!!"*";
		print("#{++$_}: [",
		      color('green bold'),$marcador, color('reset'), "] ",
		      $alvo.texto ~ "\n");
	}
}

method !nome-boletim { return $!nome-boletim.chomp(".txt").split("/")[*-1] }

method !path-boletim { return $!nome-boletim }

method !refaz-boletim {
	unlink self!path-boletim;
	spurt self!path-boletim, '',:createonly;
	for @!alvos {
		spurt self!path-boletim.IO, .marcador ~ "\n", :append;
		spurt self!path-boletim.IO, .texto    ~ "\n", :append;
	}
}

method limpar-boletim {
	use Terminal::ANSIColor;
	loop (my $i = 0; $i < @!alvos.elems; $i++) {
		if (@!alvos[$i].marcador eq '*') { @!alvos[$i].marcador = '-'; }
	}
	my $nome = self!nome-boletim;
	print "Limpando ", color('yellow bold'), "[$nome]", color('reset'), "...\n";
	self!refaz-boletim;
}
