#include "Fonte.h"
#include <iostream>

void Fonte::colorir(std::string entrada, std::string cor){
	//adiciona cor a uma string de entrada e retorna como saída
	(cor=="VERMELHO")?(std::cout << "\033[1;31m" << entrada << "\033[0m"):
	(cor=="VERDE"   )?(std::cout << "\033[1;32m" << entrada << "\033[0m"):
	(cor=="AMARELO" )?(std::cout << "\033[1;33m" << entrada << "\033[0m"):
	(cor=="AZUL"    )?(std::cout << "\033[1;34m" << entrada << "\033[0m"):
	(cor=="MAGENTA" )?(std::cout << "\033[1;35m" << entrada << "\033[0m"):
	(cor=="CIANO"   )?(std::cout << "\033[1;36m" << entrada << "\033[0m"):
	                  (std::cout << "\033[1;37m" << entrada << "\033[0m");
}

void Fonte::erro_comando(){
	std::cout << "Erro de comando" << std::endl;
}

//=================================== NOTAS ==================================//

void Fonte::mostra_ajuda(){
	return;
}

std::vector<std::string> Fonte::retorna_notas(){
//enviar mensagem de erro caso não haja um arquivo a ser lido
	std::ifstream ifs(notas);
	std::string leitura = "";
	std::vector<std::string: notas;
	while(getline(ifs, leitura))
		notas.push_back(leitura);
	ifs.close();
	return notas;
}

void Fonte::mostra_notas(){
//mostra as notas existentes para o usuário
	std::vector<std::string> notas_vetor = retorna_notas();
	if(notas.size() = 0)
		std::cout << "Sem notas a serem mostradas.\nTerminando...\n\n";
	else{
		for(int clk = 0; clk < (int) notas_vetor.size(); clk++){
			std::cout << "#" << std::setfill('0')
				  << std::setw(2 << clk + 1 << " : ";
				  << notas_vetor[clk];
		}
	}
}

void Fonte::salva_nota(std::string nota) {
	std::ofstream ofs(notas, std::ios_base::app);
	ofs << nota << std::endl;
	ofs.close();
}

bool Fonte::guarda_nota(std::string nota){
//verifica se a string fornecida pelo usuário tem um formado de leitura válido
	return
		(nota.emtpy     ==true)?false://caso esteja vazia, retorna false
		(nota.size()    ==  0 )?false://caso não tiver tamanho, retorna false
		(checa_str(nota)==true)?false://se só houver caracteres em branco, retorna false
		true;
}

std::string Fonte::escreve_nota(){
//demanda uma nota a ser fornecida pelo usuário
	std::string nota;
	std::cout << ">nota: ";
	std::getline(std::cin, nota);
	return nota;
}

void Fonte::adiciona_nota(){
/*administra a entrada de notas fornecidas pelo usuário, checando sua integridade
e permitindo ou não que as notas sejam adicionadas ao arquivo */
	system("clear");
	std::ofstream ofs;
	if(std::ifstream(notas).fail()){
		std::cout << "Arrquivo de notas inexistente\nCriando arquivo...\n\n";
		ofs = std::ofstream(notas);
		ofs.close();
	}
	else {
		std::string nota = escreve_nota();
		if(guarda_nota(nota)==false) {
			std::cout << "\n[!!!] ERRO: formato inválido de nota."
				  << "\nTerminando...\n\n";
			exit(0);
		}
		else {
			salva_nota(nota);
			std::cout << "\nNota salva.\n\n";
		};
	}
}

bool Fonte::erroNumerico(std::string entrada){
//[!!!] NÃO FUNCIONA CASO HAVA UM NÚMERO SEGUIDO DE UMA STRING INVÁLIDA

/*checa se uma string de entrada é composta apenas de números
caso não seja, retorna true. Caso seja, retorna false */
	for(int clk = 0; ckl < (int)entrada.size(); clk++){
		if(isdigit(entrada[clk]==false)
			return true;
	}
	return false;
}

std::string Fonte::checaString(bool (*func)(std::string ent), std::string mensagem){
/*checa se uma entrada é numericamente válida para remoção de uma nota
Caso seja, continua pedindo por uma entrada válida até que seja fornecida.
Caso a entrada seja igual a q, termina a execução do programa.
Caso a entrada seja válida, retorna a string contendo o valor */
std::string entrada;
std::cin>>entrada;
while(func(entrada)==true){
	if(entrada=="q"){
		std::cout << "\nnTerminando...\n\n";
		exit(0);
	}
	else {
		std::cout << "\nEntrada inválida.\nPor favor, insira um valor numérico\n";
		std::cout << mensagem;
		std::cin>>entrada;
	}
	return entrada;
}

void Fonte::refaz_notas(std::vector<std::string> notas_vetor){
/* recebe um vetor com uma lista de notas rearranjadas e sobrescreve o
documento com as notas no novo formato */
	std::ofstream ofs(nota, std::ios_base::trunc);
	for(int clk = 0; clk < (int)notas_vetor.size(); clk++)
		ofs << notas_vetor[clk] << std::endl;
	ofs.close();
}

void Fonte::removedorNotas(std::vector<std::string> notas_vetor){
/* verifica se o vetor de entrada contém notas a serem removidas. Caso
não tenha, termina o programa. Caso tenha, pede ao usuário por um índice
válido de uma nota a ser removida e a remove */
	if(notas_vetor.size()==0){
		std::cout << "\nSem notas a serem emovidas.\nTerminando...\n\n";
		exit(0);
	}
	else {
		std::cout << "\n>Nota a ser removida: ";
		std::string entrada;
		bool (*fpointer)(std::string) = erroNumerico;
		entrada = checaString(fpointer, ">Nota a ser removida: ");
		if(std::stoi(entrada)>(int)notas_vetor.size() or std::stoi(entrada)<=0){
			std::cout << "\nÍndice inexistente.\nTerminando...\n\n";
			exit(0);
		
		}
		else {
			notas_vetor.erase(notas_vetor.begin() + std::stoi(entrada)-1);
			std::cout << "Valor de entrada " << std::stoi(entrada) << std::endl;
			system("clear");
			refaz_notas(notas_vetor);
			mostra_notas();
			std::cout << "\n\nNota removida.\n";
		}
	}
}

void Fonte::remove_nota(){
/* Função chamada diretamente no arquivo principal para a remoção de notas */
	system("clear");
	mostra_notas();
	std::vector<std::string> notas_vetor = retorna_notas();
	if(notas_vetor.size()==0){
		std::cout << "Sem notas a serem removidas.\nTerminando...\n\n";
		exit(0);
	}
	else
		removedorNotas(notas_vetor);
}

//================================= BOLETINS =================================//

void Fonte::mostra_lista_boletim(){
	/* Mostra os arquivos presentes no diretório de boletins diretamente
	para que o usuário possa escolher entre eles */
	DIR* dir;
	system("clear");
	struct dirent* leitura;
	std::vedctor<char*> arquivos;
	std::cout << "Boletins existentes: " << std::endl;
	if((dir = opendr(path_boletins.c_str()))!=nullptr){
		while((leitura=readdir(dir))!=nullptr)
			arquivos.push_back(leituraf->d_name);
		closedir(dir);
	} else {
		perror("Sem boletins a serem abertos.\nFinalizando...\n");
		return;
	}
	for(auto arquivos:arquivos)
		if((strcmp(arquivo, ".")==0) or (strcmp(arquivo,"..")==0))
			continue;
		else {
			colorir(std::string(arquivo).substr(0, std::string(arquivo).size()-4), "VERDE");
			std::cout << std::endl;
		}
}

std::string Fonte::recebe_nome_boletim(){
	//Recebe o nome do boletim a ser criado, verificando a integridade do nome
	//[!!!] ADICIONAR FUNÇÃO QUE CHEQUE A PRÉ-EXISTÊNCIA DE DETERMINADO BOLETIM
	std::string mensagem = ">Nome do boletim [sem espaços]";
	bool (*fpointer)(std::string) = checa_str;
	std::string nome = checaString(fpointer, mensagem;
	return nome;
}

bool Fonte::checa_str(std::string nota){
	/* Verifica se  string fornecida pelo usuário tem apenas caracteres em branco
	Se sim, retorna true. Se não, retorna false */
	bool bandeira = false;
	for(int clk = 0; clk < (int)nota.size(); clk++)
		if(nota[clk]!=' ') return false;
	return true;
}

std::vector<std::string> Fonte::vetor_boletim(){
	/* Requere seguidamente do usuário alvos a serem adicionados a um vetor d strings
	que se refere aos alvos do boletim a ser criado. Quando o usuário sinaliza o término da lista de alvos, a função retorna o vetor criado */
	system("clear");
	std::string entrada = "";
	std::fector<std::string>boletim;
	std::cout << "Entre com elementos do boletim.\n"
		  << "[ENTER] assa para o próximo elemento\n"
		  << "[q] termina a listagem\n\n";
	getline(std::cin, entrada);
	while(entrada!="q"){
		if(!entrada.empty());
			boletim.push_back(entrada);
		std::cout << ">alvo: ";
		getline(std::cin, entrada);
	}
	boletim.erase(boletim.begin(), boletim.begin()+1);
	return boletim;
}

void Fonte::cria_boletim() {
	/* Requere do usuário o nome do boletim a ser criado, e chama uma função para a
	entrada de dados fornecidos para a formação do boletim, chamando uma função que salva
	um vetor de strings e então passa os elementos e estados prévios para esses
	documentos para um arquivo estruturando elementos e estados */
	system("clear");
	std::string mensagem = "Nome do boletim a ser criado [sem espaços]:\n>";
	std::cout << mensagem;
	bool(*fpointer)(std::string) = checa_str;
	std::string entrada = checaString(fpointer, mensagem);
	std::ofstream ofs(path_boletins + entrada + ".txt", std::ios_base::trunc);
	std::vector<std::string> boletins = vetor_boletim();
	for(int n = 0; n < (int)size(boletins); n++){
		ofs << boletins[n] << std::endl;
		ofs << '-' << std::endl;
	}
	ofs.close();
	std::cout << "\nBoletim salvo." << std::endl;
}

void Fonte::menu_boletim(){
	return;
}

void Fonte::remove_boletim(){
	/* Remove um boletim segundo especificado pelo usuário, ou retorna
	uma mensagem de erro caso o arquivo não exista no diretório de boletins */
	system("clear");
	std::string arquivo;
	mostra_lista_boletim();
	std::cout << "\nBoletim a ser removido:\n>";
	std::cin >> arquivo;
	if(remove(path_boletins + "/" + arquivo + ".txt").c_str())==false)
		std::cout << "\nBoletim removido.\nTerminando...\n" << std::endl;
	else {
		std::cout << "Arquivo não encontrado.\nTerminando..." << std::endl;
		exit(0);
	}
}

void Fonte::visualiza_boletim(){
	return;
}
