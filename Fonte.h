#ifndef FONTE_H
#define FONTE_H
#include "Boletim.h"
#include <string>

class Fonte {
	std::vector<std::string> retorna_notas();
	void salva_nota(std::string nota);
	bool guarda_nota(std::string nota);
	std::string escreve_nota();
	bool erroNumerico(std::string entrada);
	std::string checaString(bool (*func)(std::string ent), std::string mensagem);
	void refaz_notas(std::vector<std::string>notas_vetor);
	void removedorNotas(std::vector<std::string> notas_vetor);

	void colorir(std::string entrada, std::string cor);
	void mostra_lista_boletim();
	std::string recebe_nome_boletim();
	bool checa_str(std::string nota);
	std::vector<std::string>vetor_boletim();
	void cria_boletim();
public:
	void erro_comando();
	void mostra_ajuda();
	void mostra_notas();
	void adiciona_nota();
	void remove_nota();
	
	void menu_boletim();
	void remove_boletim();
	void visualiza_boletim();
	void
};

#endif
