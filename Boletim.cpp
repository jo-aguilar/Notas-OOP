#include "Boletim.h"
#include <iostream>
#include <fstream>
#include <filesystem>
#include <iomanip>
#include <algorithm>

namespace {
	const int USUARIO_MAX = 50;
	char us[USUARIO_MAX];
	std::string usuario(cuserid(us));
	std::string path_boletins = "/home/"+usuario+"/Documents/Notas/Boletins/";
};

void Boletim::titulo(){
	std::cout << "\033[1;33m" << "[ " << Boletim::retorna_nome_boletim() << " ]"
		     "\033[0m" << std::endl;
}


std::vector<Alvo> Boletim::cria_boletim (const std::string arquivo) {
/* Cria um boletim a partir de um arquivo existente com dados já fornecidos
   pelo usuário anteriormente. Caso o arquivo em questão não exista, retorna
   um vector de alvos vazio */
	std::vector<Alvo> boletim_provisorio;
	std::string boletim_doc = path_boletins + arquivo + ".txt";
	if (std::filesystem::exists(boletim_doc)==false) {
		std::cout << "Arquivo inexistente.\nTerminando..." << std::endl;
		std::vector<Alvo> vazio;
		return vazio; //caso a função detecte erro, retorna um vetor nulo
	} else {
		std::ifstream ifs;
		ifs.open(boletim_doc);
		while (!ifs.eof()){
			std::string marcador, alvo;
			std::getline(ifs, marcador);
			std::getline(ifs, alvo);
			if(alvo.empty()) break; //leitura espúria antes do fim do arquivo
			boletim_provisorio.push_back(Alvo(marcador[0], alvo));
		}
		ifs.close();
		return boletim_provisorio;
	}
}

void Boletim::mostra_boletim(){
/* Mostra o boletim em formato de lista para a visualização da configuração
   do arquivo diretamente no terminal */
   	Boletim::titulo();
	for(int clk = 0; clk < (Boletim::boletim).size(); clk++){
		std::cout << "#" << std::setfill('0') << std::setw(2)
		          << clk+1 << ": ";
		boletim[clk].mostra_alvo(); 
	}
}

void Boletim::refaz_boletim() {
/* Refaz o arquivo de alvos a partir de um objeto de Boletim configurado pelo 
   usuário durante a execução do programa. Caso o Boletim manipulado termine com
   0 elementos, o arquivo em questão é removido e o procedimento termina */ 
	std::string path_arquivo = path_boletins + Boletim::nome_arquivo_boletim+".txt";
	if((Boletim::boletim.size()-1)==0){
		remove(path_arquivo.c_str());
		return;
	} else {
		std::ofstream ofs(path_arquivo, std::ios::trunc);
		for(int clk=0; clk < Boletim::boletim.size(); clk++){
			if(Boletim::boletim[clk].retornaMarcador()=='-')
				ofs << '-' << std::endl;
			else
				ofs << '*' << std::endl;
			ofs << Boletim::boletim[clk].retornaAlvo() << std::endl;
		}
		ofs.close();
	}
}

void Boletim::limpa_boletim() {
/* Limpa um boletim com elementos o suficientes, tirando todos os marcadores
   e refazendo o boletim com a listagem sem qualquer marcação*/
	for(int clk = 0; clk < Boletim::boletim.size(); clk++)
		Boletim::boletim[clk].seta_marcador('-');
	Boletim::refaz_boletim();
}

void Boletim::atira_boletim_baixo(int indice){
/* Atira nos boletins de forma unitária, um por vez. Serve de base para a função
   que atira em boletins em mais de um elemento por vez */
	if(indice<=0 or indice>Boletim::boletim.size()){
		std::cout << "[!!!] Índice fora do tamanho da lista" << std::endl;
		return;
	} else {
		if(Boletim::boletim[indice-1].retornaMarcador()=='*'){
			std::cout << "[!!!] Alvo já marcado" << std::endl;
			return;
		} else
			Boletim::boletim[indice-1].seta_marcador('*');
	}
}


void Boletim::atira_boletim(std::vector<int>indices){
/* Atira nos boletins em formato de lista, utilizando os índices em linha separados
   por espaço fornecidos pelo usuário e checando e fazendo a marcação de cada
   elemento que foi requerido*/
	for(int clk = 0; clk < indices.size(); clk++)
		Boletim::atira_boletim_baixo(indices[clk]);
}

void Boletim::adiciona_alvo(const Alvo alvo){
/* Adiciona um novo alvo entregue do usuário para um boletim, possa ser ele novo
   ou já criado anteriormente */
	Boletim::boletim.push_back(alvo);
	std::cout << "Novo alvo adicionado a "
	          << "[ " <<  Boletim::retorna_nome_boletim() << " ]" << std::endl;
}

void Boletim::remove_alvo_baixo(const int indice){
/* Remove alvos de determinado boletim número a número, de acordo com o especificado
   pelo usuário. Caso o índice requerido esteja fora do domínio do boletim, uma frase
   de erro é mostrada e se retorna da função. Serve de base para remove_alvo() */
	if (indice <=0 or indice>Boletim::boletim.size()){
		std::cout << "Alvo de número #" << indice << " inexistente" << std::endl;
		return;
	} else {
		Boletim::boletim.erase(Boletim::boletim.begin() + indice -1);
		std::cout << "Alvo de número #" << indice 
		<< " removido de [ " << Boletim::retorna_nome_boletim() << " ]"
		<< std::endl;
	}
}

void Boletim::remove_alvo(std::vector<int> indices) {
/* Remove alvos do boletim, utilizando os índices em linha separados
   por espaço fornecidos pelo usuário e checando e fazendo a marcação de cada
   elemento que foi requerido*/
   std::vector<int>indices2 = indices;
   std::sort(indices2.begin(), indices2.begin() + indices2.size());
   for(int clk = indices2.size()-1 ; clk >=0; clk--)
   	Boletim::remove_alvo_baixo(indices2[clk]);
}

bool Boletim::alvo_marcavel(Boletim bl) {
/* Retorna true se houver algum alvo ainda não marcado dentro de um boletim;
   caso contrário, retorna false por padrão */
	std::vector<Alvo> boletim = bl.retorna_boletim();
	for(int clk = 0; clk < boletim.size(); clk++){
		if(boletim[clk].retornaMarcador()=='-')
		return true;
	}
	return false;
}

Alvo Boletim::retorna_alvo( const int indice){
/* Retorna determinado alvo como uma função de retorno comum, vindo
   como um elemento especificado do vetor de alvos do boletim */
	if(indice<0){
		std::cout << "[!!!] Erro: índice menor que 0" << std::endl;
		exit(0);
	} else
		return Boletim::boletim[indice];
}

void Boletim::troca_todos_alvos(Boletim b1) {
/* A partir de um segundo alvo fornecido pelo usuário, verifica se existem
   alvos a serem trocados dele para o objeto que contém essa função. Caso não
   haja, avisa ao usuário sobre o ocorrido. Caso haja, faz a troca de todos os
   alvos que não estejam marcados de um boletim para o outro e então refaz os
   arquivos com os boletins */
	bool marcavel = Boletim::alvo_marcavel(b1);
	std::vector<Alvo> espurio;
	if(marcavel==false){
		std::cout << "\n[!!!] Não existem alvos a serem trocados \n"
		          << "      de [ "
		          << b1.retorna_nome_boletim() << " ]" 
			  << " para [ " << Boletim::retorna_nome_boletim() << " ]"
			  << std::endl << std::endl;
	} else {
		for(int clk = b1.size()-1; clk >=0; clk--){
			if(b1.retorna_alvo(clk).retornaMarcador()=='-'){
				Alvo al(b1.retorna_alvo(clk).retornaMarcador(),
					b1.retorna_alvo(clk).retornaAlvo());
				espurio.push_back(al);
				b1.remove_alvo(std::vector<int>{clk+1});
			}
		}
	}
	for(int clk = espurio.size()-1; clk >=0; clk--)
		Boletim::adiciona_alvo(espurio[clk]);
	Boletim::refaz_boletim();
	b1.refaz_boletim();
}

void Boletim::troca_alvos_baixo(Boletim b1, const int indice) {
/* Assegura que um índice fornecido esteja dentro do domínio do tamanho do 
   boletim especificado. Caso não esteja, retorna uma mensagem de erro. Caso
   esteja, troca o alvo pedido do boletim especificado para o boletim do objeto
   que foi declarado e chamado, então refaz ambos os boletins */	
	if(indice>b1.size() or indice<1){
		std::cout << "Índice " << indice << " fora de alcance" << std::endl;
		return;
	}
	Boletim::adiciona_alvo(b1.retorna_alvo(indice-1));
	Boletim::refaz_boletim();
}

void Boletim::troca_alvos(Boletim* b1, std::vector<int>indices){
/* Troca alvos entre o ponteiro de um boletim fornecido com o vetor de uma seqüência
   de inteiros com índices a serem trocados. Primeiramente, adiciona ao boletim chamado
   os alvos do ponteiro, e então remove os alvos do ponteiro para que o objeto possa ser
   mostrado, caso se queira em uma função, da forma como foi modificado */
	std::sort(indices.begin(), indices.begin() + indices.size());
	for(int clk = 0; clk < indices.size(); clk++)
		Boletim::troca_alvos_baixo(*b1, indices[clk]);
	for(int clk = indices.size(); clk>=0; clk--)
		b1->remove_alvo(std::vector<int>{indices[clk]});
	b1->refaz_boletim();
}
