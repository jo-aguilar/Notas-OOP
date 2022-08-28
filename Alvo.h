#ifndef ALVO_H
#define ALVO_H
#include <string>

class Alvo {
	std::string alvo;
	char marcador;

public:
	Alvo (char ss, std::string aa): marcador(ss), alvo(aa) {}
	~Alvo () {}
	std::string retornaAlvo() { return alvo; }
	char    retornaMarcador() { return marcador; }
	void mostra_alvo();
	void seta_marcador(const char entrada) {marcador = entrada; }
};

#endif
