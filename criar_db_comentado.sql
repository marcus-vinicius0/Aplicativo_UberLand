
-- -----------------------------------------------------
-- Criando o esquema uberland
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS uberland CASCADE;
CREATE SCHEMA uberland;
SET search_path TO uberland;

-- -----------------------------------------------------
-- Tabela MOTORISTA
-- -----------------------------------------------------
CREATE TABLE motorista (
	identificador SERIAL,
	cpf CHAR(11) NOT NULL,
	nome_completo VARCHAR(50) NOT NULL,
	endereco VARCHAR(150) NOT NULL,
	data_nascimento DATE NOT NULL,
	cnh CHAR(9) NOT NULL,
	status VARCHAR(50),
	avaliacao REAL,
	nro_corridas INT,
	--restrições
	CONSTRAINT pkmotorista PRIMARY KEY (identificador)
);

-- -----------------------------------------------------
-- Tabela USUARIO
-- -----------------------------------------------------
CREATE TABLE usuario (
	cpf CHAR(11),
	nome VARCHAR(50) NOT NULL,
	email VARCHAR(150) NOT NULL,
	sexo CHAR(9) NOT NULL,
	data_nascimento DATE NOT NULL,
	nro_corridas INT,
	avaliacao REAL,
	tipo VARCHAR(50) NOT NULL,
	porcetagem_de_desconto REAL,
	--restrições
	CONSTRAINT pkusuario PRIMARY KEY (cpf)
);

-- -----------------------------------------------------
-- Tabela NRO_CELULAR
-- -----------------------------------------------------
CREATE TABLE nro_celular (
	cpf_usu VARCHAR(11),
	nro_celular VARCHAR(11),
	CONSTRAINT pknrocelular PRIMARY KEY (cpf_usu, nro_celular),
	CONSTRAINT fkcpfnrocelular FOREIGN KEY (cpf_usu) REFERENCES usuario(cpf)
); 

-- -----------------------------------------------------
-- Tabela VEICULO
-- -----------------------------------------------------
CREATE TABLE veiculo (
    placa VARCHAR(7),
	chassi VARCHAR(17),
	nome VARCHAR(50) NOT NULL,
	ano INT NOT NULL,
	marca VARCHAR(50) NOT NULL,
	status VARCHAR(50),
	num_passageiro INT NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	m_possui INT NOT NULL,
	cilindrada REAL,
	ult_revisao DATE,
	taxa REAL,
	--restrições
	CONSTRAINT pkveiculo PRIMARY KEY (placa, chassi),
	CONSTRAINT fkmotoristaveiculo FOREIGN KEY (m_possui) REFERENCES motorista(identificador)
);

-- -----------------------------------------------------
-- Tabela ACESSORIO
-- -----------------------------------------------------
CREATE TABLE acessorio (
	placa VARCHAR(7),
	chassi VARCHAR(17),
	v_acessorio VARCHAR(50) NOT NULL,
	--restrições
	CONSTRAINT pkacessorio PRIMARY KEY (placa, chassi, v_acessorio),
	CONSTRAINT fkveiculoacessorio FOREIGN KEY (placa, chassi) REFERENCES veiculo(placa, chassi)
);

-- -----------------------------------------------------
-- Tabela STATUS
-- -----------------------------------------------------
CREATE TABLE status (
	id_status SERIAL,
	descricao CHAR(50) NOT NULL,
	autor_cancelamento CHAR(9),
	--restrições
	CONSTRAINT pkstatus PRIMARY KEY (id_status)
);

-- -----------------------------------------------------
-- Tabela CUPOM_SORTEIO
-- -----------------------------------------------------
CREATE TABLE cupom_sorteio (
	id_cupom SERIAL,
	data_validade DATE NOT NULL,
	--restrições
	CONSTRAINT pkcupom PRIMARY KEY (id_cupom)
);

-- -----------------------------------------------------
-- Tabela FORMA_PAGAMENTO
-- -----------------------------------------------------
CREATE TABLE forma_pagamento (
	id_pagamento SERIAL,
	tipo_pagamento CHAR(50) NOT NULL,
	--restrições
	CONSTRAINT pkforma PRIMARY KEY (id_pagamento)
);

-- -----------------------------------------------------
-- Tabela VIAGEM
-- -----------------------------------------------------
CREATE TABLE viagem (
	cpf_usu CHAR(11),
	placa_ve CHAR(7),
	chassi_ve CHAR(17),
	data_hora_solicitacao TIMESTAMP,
	valor_motorista REAL NOT NULL,
	valor_app REAL NOT NULL,
	valor_estimado REAL NOT NULL,
	horario_motorista TIMESTAMP,
	custo REAL NOT NULL,
	duracao INT,
	gorjeta REAL,
	horario_inicio TIMESTAMP,
	horario_fim TIMESTAMP,
	status INT,
	cupom INT,
	pagamento INT,
	--restrições
	CONSTRAINT pkviagem PRIMARY KEY (cpf_usu, placa_ve, chassi_ve, data_hora_solicitacao),
	CONSTRAINT fkcpfviagem FOREIGN KEY (cpf_usu) REFERENCES usuario(cpf),
	CONSTRAINT fkveiculoviagem FOREIGN KEY (placa_ve, chassi_ve) REFERENCES veiculo(placa, chassi),
	CONSTRAINT fkstatusviagem FOREIGN KEY (status) REFERENCES status(id_status),
	CONSTRAINT fkcupomviagem FOREIGN KEY (cupom) REFERENCES cupom_sorteio(id_cupom),
	CONSTRAINT fkpagamentoviagem FOREIGN KEY (pagamento) REFERENCES forma_pagamento(id_pagamento)
);

-- -----------------------------------------------------
-- Tabela PONTO_DE_PARADA
-- -----------------------------------------------------
CREATE TABLE ponto_de_parada (
	cpf_usu CHAR(11),
	placa_ve CHAR(7),
	chassi_ve CHAR(17),
	data_hora_solicitacao TIMESTAMP,
	vi_ponto_de_parada CHAR(150),
	--restrições
	CONSTRAINT pkparada PRIMARY KEY (cpf_usu, placa_ve, chassi_ve, data_hora_solicitacao, vi_ponto_de_parada),
	CONSTRAINT fkviagemparada FOREIGN KEY (cpf_usu, placa_ve, chassi_ve, data_hora_solicitacao) REFERENCES viagem(cpf_usu, placa_ve, chassi_ve, data_hora_solicitacao)
);