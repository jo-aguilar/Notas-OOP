#ifndef BOLETIM_H
#define BOLETIM_H
#include <string>
#include <vector>
#include "Alvo.h"

//================================ BUGS ===============================================//
// * Ainda existe um bug minotirário em que algum alvo de índice 0 tenta ser alcançado //
//   em algum momento, onde "Alvo de número #x inexistente" é enviado como mensagem    //
//=====================================================================================//

class Boletim {
	std::string nome_arquivo_boletim; //nome do arquivo de criação
	std::vector<Alvo> boletim;        //vetor com os alvos do arquivo
	std::vector<Alvo> cria_boletim(const std::string arquivo);
	void atira_boletim_baixo(const int indice);
	void remove_alvo_baixo(const int indice);
	bool alvo_marcavel(const Boletim bl);
	void troca_alvos_baixo(Boletim b1, const int indice);

public:
	Boletim(const std::string arquivo): nome_arquivo_boletim(arquivo){
		boletim = cria_boletim(nome_arquivo_boletim);
	}
	~Boletim(){}
	std::string retorna_nome_boletim() { return nome_arquivo_boletim; }
	std::vector<Alvo> retorna_boletim () { return boletim; }
	Alvo retorna_alvo (const int indice);
	const int size() { return boletim.size(); }
	void titulo();
	void mostra_boletim();
	void refaz_boletim();
	void atira_boletim(std::vector<int>indices);
	void limpa_boletim();
	void adiciona_alvo(const Alvo alvo);
	void remove_alvo(std::vector<int> indices);
	void troca_todos_alvos(Boletim b1);
	void troca_alvos(Boletim* b1, std::vector<int>indices);
};

#endif
