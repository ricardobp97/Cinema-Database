Use Cinema;

-- ----------------------------- STORED PROCEDURES -----------------------------

DROP PROCEDURE IF EXISTS inserir_cliente;
DELIMITER &&
CREATE PROCEDURE inserir_cliente(IN nif INT,
								 IN nome VARCHAR(45),
								 IN tipo CHAR)
BEGIN
	DECLARE erro BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;

	INSERT INTO Cliente VALUES (nif, nome, tipo);

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&


DROP PROCEDURE IF EXISTS inserir_funcionário;
DELIMITER &&
CREATE PROCEDURE inserir_funcionário(IN id INT,
									IN nome VARCHAR(45))
BEGIN
	DECLARE erro BOOL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;

	INSERT INTO Funcionário VALUES (id, nome);

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&


DROP PROCEDURE IF EXISTS registar_bilhete;
DELIMITER &&
CREATE PROCEDURE registar_bilhete(IN data_emissao DATE,
									IN lugar INT,
                                    IN nif_cliente INT,
                                    IN id_sessao INT,
                                    IN id_func INT)
BEGIN
	DECLARE erro BOOL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;
    
	INSERT INTO Bilhete VALUES ((SELECT calcula_idBilhete()), data_emissao, lugar, (SELECT calcula_preco(nif_cliente)), nif_cliente, id_sessao, id_func);

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&


DROP PROCEDURE IF EXISTS inserir_filme;
DELIMITER &&
CREATE PROCEDURE inserir_filme(IN id INT,
								IN nome VARCHAR(45),
                                IN descricao TEXT,
                                IN classificacao DECIMAL(2,1))
BEGIN
	DECLARE erro BOOL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;

	INSERT INTO Filme VALUES (id, nome, descricao, classificacao);

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&


DROP PROCEDURE IF EXISTS inserir_sessao;
DELIMITER &&
CREATE PROCEDURE inserir_sessao(IN data DATE,
								IN hora TIME,
                                IN duracao TIME,
                                IN nrSala INT,
                                IN filme INT)
BEGIN
	DECLARE erro BOOL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;

	INSERT INTO Sessão VALUES ((SELECT calcula_idSessão()), 4.6, data, hora, duracao, nrSala, filme);

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&


-- Lista de lugares disponíveis para uma determinada sessão
DROP PROCEDURE IF EXISTS lista_lugares_disponiveis;
DELIMITER &&
CREATE PROCEDURE lista_lugares_disponiveis(IN id INT)
BEGIN
	DECLARE erro BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;

	SELECT ls.idLugar, ls.Número_Cadeira, ls.Fila FROM
		(SELECT l.idLugar, l.Número_Cadeira, l.Fila FROM Lugar l, Sessão s
			WHERE l.Nr_Sala = S.Nr_Sala and S.idSessão = id) AS ls
				LEFT JOIN (SELECT b.Lugar FROM Bilhete b
								WHERE b.Sessão_id = id) AS lb
									ON ls.idLugar = lb.Lugar
					WHERE lb.Lugar IS null;

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&


-- Lista de sessões de um determinado filme numa determinada data
DROP PROCEDURE IF EXISTS sessoesPorFilme;
DELIMITER &&
CREATE PROCEDURE sessoesPorFilme (IN nome VARCHAR(45),
									IN data DATE)
BEGIN
	DECLARE erro BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro=1;
	START TRANSACTION;

	SELECT S.idSessão, S.Hora_Início, F.Nome FROM Sessão AS S
		INNER JOIN Filme AS F ON S.Filme_id = F.idFilme
		WHERE F.Nome = nome AND S.Data = data;

	IF erro
		THEN ROLLBACK;
		ELSE COMMIT;
	END IF;
END &&
DELIMITER &&