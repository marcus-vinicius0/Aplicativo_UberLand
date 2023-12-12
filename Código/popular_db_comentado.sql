
SET search_path TO uberland;

-- -----------------------------------------------------
-- Tuplas MOTORISTA
-- -----------------------------------------------------
INSERT INTO motorista(cpf, nome_completo, endereco, data_nascimento, cnh, status, avaliacao, nro_corridas)
VALUES('93884573823', 'Ednaldo Pereira da Silva', 'Rua Domingos, São João, 1000', '07-12-1987','123456789', 'Disponível', 4.96, 1003 ),
      ('45439884579', 'Dorival Junior Santos', 'Rua Francisco, Santa Maria, 12', '29-03-1978','987654321', 'Em Viagem', 4.99, 569 ),
	  ('10293749382', 'Roberto da Silva Pereira', 'Rua Serra das Vilas, Granada, 342', '09-10-1999','739374930', 'A caminho', 5.00, 110 ),
	  ('84950371036', 'Marcus Vinicius da Silva', 'Rua Adair dos Santos, Santa Luzia, 679', '13-06-2001','640211829', 'Disponível', 4.87, 3003 ),
	  ('90845094562', 'Ryan Caio da Neves', 'Rua Iraque, Bairro Brasil, 1014', '02-02-2002','883944011', 'Em Viagem', 4.99, 230 );
	  
-- -----------------------------------------------------
-- Tuplas USUARIO
-- -----------------------------------------------------
INSERT INTO usuario(cpf, nome, email, sexo, data_nascimento, nro_corridas, avaliacao, tipo, porcetagem_de_desconto)
VALUES('29483930293', 'Maria Cristini de Oliveira', 'mariacristini87@gmail.com', 'feminino','01-01-2001', 98, 4.99, 'VIP', 10.0 ),
	  ('73925184627', 'Emerson da Silva Costa', 'emerson777@gmail.com', 'masculino','24-05-1992', 32, 4.68, 'VIP', 10.0 ),
	  ('03927384958', 'Fernanda Bernades Peixoto', 'fer55@gmail.com', 'feminino','09-09-2000', 122, 4.97, 'Comum', NULL ),
	  ('52772769046', 'Diniz do Santos Camargo', 'camargott@gmail.com', 'masculino','10-04-2003', 56, 4.95, 'VIP', 10.0 ),
	  ('77601960080', 'Eduarda da Silva Gomes', 'duda888@outlook.com', 'feminino','30-06-2004', 11, 4.99, 'Comum', NULL );
	  
-- -----------------------------------------------------
-- Tuplas NRO_CELULAR
-- -----------------------------------------------------	  
INSERT INTO nro_celular(cpf_usu, nro_celular)
VALUES ('29483930293', '34993214567'),
	   ('73925184627', '31998877901'),
	   ('03927384958', '12983365078'),
	   ('52772769046', '34992347105'),
	   ('77601960080', '66984701283');

-- -----------------------------------------------------
-- Tuplas VEICULO
-- -----------------------------------------------------
INSERT INTO veiculo(placa, chassi, nome, ano, marca, status, num_passageiro, tipo, m_possui, cilindrada, ult_revisao, taxa)
VALUES('ABL1646', '66KC7P9Xxkza90902', 'Gol', 2010, 'Volkswagen', 'Ativo', 2, 'UberX', 1, 1.0, '10-12-2020', 10.0 ),
	  ('NAL1030', '77t3SuSkRc4eA1540', 'Celta', 2005, 'Chevrolet', 'Ativo', 1, 'UberX', 2, 1.0, '05-10-2022', 5.0 ),
	  ('MVW5324', '418LPjcu0AsDS9778', 'Jeep Compass', 2018, 'Jeep', 'Ativo', 3, 'UberBlack', 3, 2.1, '20-12-2022', 1.0 ),
	  ('JVB8259', '4A6yx1UrdlL6x8619', 'Titan 160', 2024, 'Honda', 'Ativo', 1, 'UberMoto', 4, 162.7, '15-03-2023', 14.0 ),
	  ('JOO9312', '7XDTAKVhEcUvz9180', 'BMW 320i', 2012, 'BWM', 'Ativo', 2, 'UberComfort', 5, 2.9, '21-08-2023', 20.0 );
	  
-- -----------------------------------------------------
-- Tuplas ACESSORIO
-- -----------------------------------------------------
INSERT INTO  acessorio (placa, chassi, v_acessorio)
VALUES('ABL1646', '66KC7P9Xxkza90902', 'Ar-condicionado'),
	  ('ABL1646', '66KC7P9Xxkza90902', 'Teto solar'),
	  ('NAL1030', '77t3SuSkRc4eA1540', 'Ar-condicionado'),
	  ('MVW5324', '418LPjcu0AsDS9778', '4 portas'),
	  ('JOO9312', '7XDTAKVhEcUvz9180', 'Central multimídia');
	  	  
-- -----------------------------------------------------
-- Tuplas STATUS
-- -----------------------------------------------------
INSERT INTO status(descricao, autor_cancelamento)
VALUES('Cancelada antes do início', 'Usuário'),
 	  ('Cancelada durante a viagem', 'Usuário'),
	  ('Cancelada antes do início', 'Motorista'),
	  ('Cancelada durante a viagem', 'Motorista'),
	  ('Realizada', NULL);

-- -----------------------------------------------------
-- Tuplas CUPOM_SORTEIO
-- -----------------------------------------------------
INSERT INTO cupom_sorteio(data_validade)
VALUES('2022-03-12'),
	  ('2023-10-16'),
	  ('2023-11-10'),
	  ('2023-12-25'),
	  ('2024-03-12');

-- -----------------------------------------------------
-- Tuplas FORMA_PAGAMENTO
-- -----------------------------------------------------
INSERT INTO forma_pagamento(tipo_pagamento)
VALUES('Cartão de crédito'),
	  ('Cartão de débito'),
	  ('Dinheiro'),
	  ('Pix'),
	  ('Link de pagamento');

-- -----------------------------------------------------
-- Tuplas VIAGEM
-- -----------------------------------------------------
INSERT INTO viagem(cpf_usu, placa_ve, chassi_ve, data_hora_solicitacao, valor_motorista, valor_app, valor_estimado, horario_motorista, custo, duracao, gorjeta, horario_inicio, horario_fim, status, cupom, pagamento)
VALUES('29483930293', 'ABL1646', '66KC7P9Xxkza90902', '2022-02-24 12:00:30', 20.40, 5.60, 26.0, '2022-02-24 12:04:10', 4.5, 10, NULL, '2022-02-24 12:04:40', '2022-02-24 12:14:40', 5, 1, 4),
	  ('29483930293', 'ABL1646', '66KC7P9Xxkza90902', '2023-03-12 09:30:15', 15.75, 2.25, 18.0, '2023-03-12 09:33:15', 2.0, 5, 3, '2023-03-12 09:33:35', '2023-03-12 09:38:35', 1, NULL, NULL),
	  ('73925184627', 'NAL1030', '77t3SuSkRc4eA1540', '2023-05-03 15:12:45', 31.90, 8.30, 40.20, '2023-05-03 15:14:45', 6.25, 15, NULL, '2023-05-03 15:15:00', '2023-05-03 15:30:00', 2, 4, 3),
	  ('03927384958', 'MVW5324', '418LPjcu0AsDS9778', '2023-08-27 10:27:00', 7.50, 1.50, 9.0, '2023-08-27 10:30:00', 1.0, 6, 6, '2023-08-27 10:30:20', '2023-08-27 10:36:20', 3, NULL, NULL),
	  ('77601960080', 'JVB8259', '4A6yx1UrdlL6x8619', '2023-10-11 20:03:20', 40.10, 10.50, 50.60, '2023-10-11 20:05:40', 4.5, 23, NULL, '2023-10-11 20:06:00', '2023-10-11 20:29:00', 5, 3, 1);

-- -----------------------------------------------------
-- Tuplas PONTO_DE_PARADA
-- -----------------------------------------------------
INSERT INTO ponto_de_parada (cpf_usu, placa_ve, chassi_ve, data_hora_solicitacao, vi_ponto_de_parada)
VALUES('29483930293', 'ABL1646', '66KC7P9Xxkza90902', '2022-02-24 12:00:30', 'Rua Rodrigues da Cunha, 526'),
	  ('29483930293', 'ABL1646', '66KC7P9Xxkza90902', '2022-02-24 12:00:30', 'Av. Floriano Peixoto, 1713'),
	  ('73925184627', 'NAL1030', '77t3SuSkRc4eA1540', '2023-05-03 15:12:45', 'Av. Vasconcelos Costa, 270'),
	  ('73925184627', 'NAL1030', '77t3SuSkRc4eA1540', '2023-05-03 15:12:45', 'Av. Afonso Pena, 470'),
	  ('73925184627', 'NAL1030', '77t3SuSkRc4eA1540', '2023-05-03 15:12:45', 'Rua México, 3000');
