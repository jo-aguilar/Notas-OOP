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

method tamanho { 
	self!preenche-boletim;
	return @!alvos.elems 
	}

method !preenche-boletim {
	if @!alvos.elems == 0 {
		my @entradas-boletim;
		for $!nome-boletim.IO.lines -> $linhas {
			@entradas-boletim.push($linhas);
		}
	
		loop (my $i = 0; $i < @entradas-boletim.elems; $i+=2) {
			@!alvos.push(Alvo.new(:marcador(@entradas-boletim[$i]), 
				 	      :texto(@entradas-boletim[$i+1])));
		}
	}
}

method mostra-boletim (Bool:D $limpa-tela = True) {
	use Terminal::ANSIColor;
	if $limpa-tela == True { shell 'clear' };

	my $nome = $!nome-boletim.chomp(".txt").split("/");
	print color('green bold'), "[" ~ $nome[*-1] ~ "]\n", color('reset');
	self!preenche-boletim;
	for @!alvos -> $alvo {
		my $marcador = $alvo.marcador eq "-"??" "!!"✓";
		print("#{++$_}: [",
		      color('green bold'), $marcador, color('reset'), "] ",
		      $alvo.texto ~ "\n");
	}
	say '';
}

method nome-boletim { return $!nome-boletim.chomp(".txt").split("/")[*-1] }

method !path-boletim { return $!nome-boletim }

method retorna-alvo (Int:D $indice) {
	return @!alvos[$indice];
}

method remove-alvo (Int:D $indice) {
	use Adverb::Eject;
	@!alvos[$indice] :eject;
}

method adiciona-alvo (Alvo:D $alvo) {
	@!alvos.push($alvo);
}

method refaz-boletim {
	unlink self!path-boletim;
	spurt self!path-boletim, '',:createonly;
	for @!alvos {
		spurt self!path-boletim.IO, .marcador ~ "\n", :append;
		spurt self!path-boletim.IO, .texto    ~ "\n", :append;
	}
}

method atira-alvo (Int:D $indice) {
	@!alvos[$indice].marcador = '*';
	self.refaz-boletim;
}

method limpar-boletim {
	use Terminal::ANSIColor;
	self!preenche-boletim;
	loop (my $i = 0; $i < @!alvos.elems; $i++) {
		if (@!alvos[$i].marcador eq '*') { @!alvos[$i].marcador = '-'; }
	}
	my $nome = self.nome-boletim;
	print "Limpando ", color('yellow bold'), "[$nome]", color('reset'), "...\n";
	self.refaz-boletim;
}
