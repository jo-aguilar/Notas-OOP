#include "Alvo.h"
#include <iostream>

void Alvo::mostra_alvo () {
	if ( Alvo::retornaMarcador()=='-') { std::cout << "[ ] "; }
	else { std::cout << "["
			 << "\033[1;32m" << "\u2714" << "\033[0m"
			 <<  "] "; }
	std::cout << Alvo::retornaAlvo() << std::endl;
}


