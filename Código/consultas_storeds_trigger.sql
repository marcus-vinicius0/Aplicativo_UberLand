-----------------------------------------------------------------------------------------
-- Nesse arquivo temos as 10 consultas, duas Stored procedure e o Trigger com
-- o respectivo procedure
-----------------------------------------------------------------------------------------

SET search_path TO uberland;

-----------------------------------------------------------------------------------------
-- Consulta para identificar se há alguma relação entre a avaliação do motorista
-- e a quantidade de acessórios presente nos veículos que ele utiliza nas viagens
-----------------------------------------------------------------------------------------
WITH veiculo_viagem_acessorio AS (
    SELECT
        v.placa,
		v.chassi,
        COUNT(DISTINCT vi.data_hora_solicitacao) numero_de_viagens,
        COUNT(DISTINCT a.v_acessorio) numero_de_acessorios
    FROM veiculo v
    LEFT JOIN viagem vi ON v.placa = vi.placa_ve
    LEFT JOIN acessorio a ON v.placa = a.placa AND v.chassi = a.chassi
    GROUP BY v.placa, v.chassi
),

motorista_media_acessorio_viagem AS (
	SELECT
		m.cpf,
		m.nome_completo,
		m.avaliacao,
		CASE
			WHEN SUM(vva.numero_de_viagens) > 0 THEN (SUM(vva.numero_de_acessorios) * SUM(vva.numero_de_viagens))::REAL / COUNT(v.m_possui)::REAL
			ELSE 0
		END media_de_acessorios_por_viagem
	FROM
		motorista m
	INNER JOIN veiculo v ON m.identificador = v.m_possui
	LEFT JOIN veiculo_viagem_acessorio vva ON v.placa = vva.placa AND v.chassi = vva.chassi
	GROUP BY m.cpf, m.nome_completo, m.avaliacao
)

SELECT
	CASE
        	WHEN mmav.avaliacao >= 1 AND mmav.avaliacao < 2 THEN '1 a 2'
        	WHEN mmav.avaliacao >= 2 AND mmav.avaliacao < 3 THEN '2 a 3'
        	WHEN mmav.avaliacao >= 3 AND mmav.avaliacao < 4 THEN '3 a 4'
        	WHEN mmav.avaliacao >= 4 AND mmav.avaliacao <= 5 THEN '4 a 5'
        ELSE 'Outro'
	END AS 
		intervalo_avaliacao,
		AVG(mmav.media_de_acessorios_por_viagem) media_de_acessorios_por_viagem
FROM motorista_media_acessorio_viagem mmav
GROUP BY intervalo_avaliacao;

-----------------------------------------------------------------------------------------
-- Consulta para listar todos os usuários com mais de 100 corridas nos últimos 6 meses
-----------------------------------------------------------------------------------------
SELECT u.cpf, u.nome, COUNT(v.cpf_usu) AS numero_de_corridas
FROM usuario u
LEFT JOIN viagem v ON u.cpf = v.cpf_usu
WHERE v.data_hora_solicitacao >= NOW() - INTERVAL '6 months'
GROUP BY u.cpf, u.nome
HAVING COUNT(v.cpf_usu) > 100;

-----------------------------------------------------------------------------------------
-- Consulta para contar o número de viagens por usuários VIP com avaliação maior que 4.5
-----------------------------------------------------------------------------------------
SELECT u.nome, u.tipo, COUNT(v.cpf_usu) AS numero_de_viagens
FROM usuario u
JOIN viagem v ON u.cpf = v.cpf_usu
WHERE u.tipo = 'VIP'
GROUP BY u.nome, u.tipo, u.avaliacao
HAVING u.avaliacao > 4.5;

-----------------------------------------------------------------------------------------
-- Consulta para contar o número de viagens realizadas no último mês
-----------------------------------------------------------------------------------------
SELECT COUNT(*) AS total_viagens
FROM viagem
WHERE EXTRACT(YEAR FROM data_hora_solicitacao) = EXTRACT(YEAR FROM NOW()) AND EXTRACT(MONTH FROM data_hora_solicitacao) = EXTRACT(MONTH FROM NOW() - INTERVAL '1 month');

-----------------------------------------------------------------------------------------
-- Consulta para saber qual a porcentagem de homens e mulheres que fizeram viagens
-----------------------------------------------------------------------------------------

SELECT
    u.sexo,
    COUNT(v.cpf_usu) AS total_pessoas_viajaram,
    ROUND((COUNT(v.cpf_usu) * 100.0) / (SELECT COUNT(cpf_usu) FROM viagem v), 2) AS porcentagem
FROM
    viagem v, usuario u
WHERE
    u.cpf = v.cpf_usu
GROUP BY
    u.sexo;

-----------------------------------------------------------------------------------------
-- Consulta para saber qual a porcentagem de cada faixa etária que fizeram viagens nos últimos 7 meses
-----------------------------------------------------------------------------------------

SELECT
    CASE
		WHEN EXTRACT(YEAR FROM AGE(NOW(), data_nascimento)) < 18 THEN '17-'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), data_nascimento)) BETWEEN 18 AND 29 THEN '18-29'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), data_nascimento)) BETWEEN 30 AND 39 THEN '30-39'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), data_nascimento)) BETWEEN 40 AND 49 THEN '40-49'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), data_nascimento)) BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS faixa_etaria,
    COUNT(cpf) AS total_pessoas_viajaram,
	ROUND((COUNT(cpf_usu) * 100.0) / (SELECT COUNT(cpf_usu) FROM viagem WHERE data_hora_solicitacao >= CURRENT_DATE - INTERVAL '7 months'), 2) AS porcentagem
FROM
    usuario, viagem
WHERE
	cpf = cpf_usu AND
	data_hora_solicitacao >= NOW() - INTERVAL '7 months'
GROUP BY
    faixa_etaria
ORDER BY
    faixa_etaria;



------------------------------
-- Consulta para Encontrar o total de viagens por usuário
------------------------------

SELECT cpf_usu, COUNT(*) AS total_viagens
FROM viagem
GROUP BY cpf_usu;

------------------------------
-- Consulta para Identificar Usuários com Maior Número de Pontos de Parada
------------------------------

SELECT
    u.nome AS usuario,
    COUNT(p.vi_ponto_de_parada) AS total_pontos_parada
FROM
    usuario u
    LEFT JOIN ponto_de_parada p ON u.cpf = p.cpf_usu
GROUP BY
    u.nome
ORDER BY
    total_pontos_parada DESC;

------------------------------
-- Consulta para Calcular a Receita Total por Forma de Pagamento:
------------------------------

SELECT
    fp.tipo_pagamento,
    SUM(v.custo) AS receita_total
FROM
    forma_pagamento fp
    LEFT JOIN viagem v ON fp.id_pagamento = v.pagamento
GROUP BY
    fp.tipo_pagamento
ORDER BY
    receita_total DESC;



-----------------------------------------------------------------------------------------
-- Consultas para obter informações sobre os veículos usados em viagens nos últimos 8 meses.
-----------------------------------------------------------------------------------------

SELECT v.*, ve.*
FROM viagem v
JOIN veiculo ve ON v.placa_ve = ve.placa AND v.chassi_ve = ve.chassi
WHERE v.horario_inicio >= CURRENT_DATE - INTERVAL '8 months';


-----------------------------------------------------------------------------------------
--                                     Stored Procedure
-----------------------------------------------------------------------------------------
/* Stored Procedure que vai calcular estatísticas sobre as viagens de um usuário nos últimos 8 meses, incluindo o número total de viagens, a média de custo por viagem e a classificação média dos motoristas.s
*/
-----------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION estatisticas_viagens_usuario(
    p_nro_usu CHAR(11),
    OUT total_viagens INT,
    OUT media_custo REAL,
    OUT media_classificacao_motorista REAL
)
AS
$$
DECLARE
    total_custo REAL := 0;
    total_classificacao_motorista REAL := 0;
BEGIN
    -- Calcular o número total de viagens
    SELECT COUNT(*) INTO total_viagens
    FROM viagem
    WHERE nro_usu = p_nro_usu AND horario_inicio >= CURRENT_DATE - INTERVAL '8 months';

    -- Calcular a média de custo por viagem
    SELECT COALESCE(AVG(custo), 0) INTO media_custo
    FROM viagem
    WHERE nro_usu = p_nro_usu AND horario_inicio >= CURRENT_DATE - INTERVAL '8 months';

    -- Calcular a classificação média dos motoristas
    SELECT COALESCE(AVG(avaliacao), 0) INTO media_classificacao_motorista
    FROM motorista
    WHERE identificador IN (
        SELECT DISTINCT m_realiza
        FROM viagem
        WHERE nro_usu = p_nro_usu AND horario_inicio >= CURRENT_DATE - INTERVAL '8 months'
    );

    -- Retornar os resultados
    RETURN;
END;
$$ LANGUAGE plpgsql;



-----------------------------------------------------------------------------------------
--                                    TRIGGER
-----------------------------------------------------------------------------------------
/* TRIGGER que atualiza o status do motorista automaticamente para inativo se ele não 
fizer nenhuma viagem dentro de 30 dias
*/
-----------------------------------------------------------------------------------------

-- Stored Procedure para Atualizar Status do Motorista
CREATE OR REPLACE PROCEDURE atualizar_status_motorista()
AS
$$
DECLARE
    v_data_limite DATE;
BEGIN
    -- Define a data limite como 30 dias atrás a partir da data atual
    v_data_limite := CURRENT_DATE - INTERVAL '30 days';

    -- Atualizar o status do motorista para "Inativo" se não houver viagens nos últimos 30 dias
	UPDATE motorista
    SET status = CASE
                    WHEN EXISTS (
                        SELECT 1
                        FROM veiculo ve
                        JOIN viagem v ON ve.placa = v.placa_ve AND ve.chassi = v.chassi_ve
                        WHERE motorista.identificador = ve.m_possui
                            AND v.horario_fim IS NOT NULL
                            AND v.horario_fim > v_data_limite
                    ) THEN 'Ativo'
                    ELSE 'Inativo'
                END;
END;
$$
LANGUAGE plpgsql;

-- Trigger para Atualizar Status do Motorista Após Viagem
CREATE OR REPLACE FUNCTION trigger_atualizar_status_motorista()
RETURNS TRIGGER AS
$$
BEGIN
    -- Chama a stored procedure para atualizar o status do motorista
    CALL atualizar_status_motorista();

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER after_insert_viagem
AFTER INSERT
ON viagem
FOR EACH ROW
EXECUTE FUNCTION trigger_atualizar_status_motorista();