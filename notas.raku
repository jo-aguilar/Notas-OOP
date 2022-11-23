#!/bin/env perl6

use lib <lib ./Classes/>;
use Fonte;

sub MAIN (*@ARGS) {
	my Str $diretorio-principal = $*HOME ~ "/Documents/Notas/";
	my Str $boletins            = $diretorio-principal ~ "Boletins/";
	my Fonte $fo = Fonte.new;

	shell 'clear';
	if (!$diretorio-principal.IO.e) {
		print "\nCriando diretório de base.\n\n";
		mkdir ($diretorio-principal.IO);
		mkdir ($boletins.IO);
	}

	if (@ARGS.elems==0) {
		say q:to/END/; 
		[!!!] Para uma listagem de todos os comandos existentes
		      digite [notas ajuda]
		END
		$fo.mostra-ajuda;
	}

	elsif (@ARGS.elems==1) {
		if    (@ARGS[0] eqv "ajuda")   { $fo.mostra-ajuda;  }
		elsif (@ARGS[0] eqv "nota" )   { $fo.adiciona-nota; }
		elsif (@ARGS[0] eqv "boletim") { $fo.menu-boletim;  }
		else                           { $fo.erro-comando;  }
	}	

	elsif (@ARGS.elems==2) {
		if (@ARGS[1] eqv "rm") {
			if    (@ARGS[0] eqv "nota")     { $fo.remove-nota;    }
			elsif (@ARGS[0] eqv "boletim")  { $fo.remove-boletim; }
			else                            { $fo.erro-comando;   }
		}
		elsif (@ARGS[1] eqv "vis") {
			if    (@ARGS[0] eqv "boletim") { $fo.visualiza-boletim; }
			elsif (@ARGS[0] eqv "notas"  ) { $fo.visualiza-notas;   }
			else                           { $fo.erro-comando;      }
		}
		else { $fo.erro-comando; }
	}
	else { print "[ERRO]: Quantidade incompatível de comandos\n\n"; }

}











