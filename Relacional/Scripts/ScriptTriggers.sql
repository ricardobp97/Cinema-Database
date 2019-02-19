Use Cinema;

-- ----------------------------- TRIGGERS -----------------------------

-- Impede que o cliente compre um bilhete para uma sessao que ja foi realizada
DROP TRIGGER IF EXISTS dataBilhete;
DELIMITER &&
CREATE TRIGGER dataBilhete
BEFORE INSERT ON Bilhete
FOR EACH ROW
BEGIN
	DECLARE message VARCHAR(100);
    
    IF(SELECT ((SELECT S.Data FROM Sessão AS S WHERE S.idSessão = NEW.Sessão_id) < NEW.Data_Emissão))
    THEN SET message = 'Esta Sessão já foi realizada.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message;
    
    END IF;
END &&
DELIMITER &&


-- Impede que o cliente escolha um lugar que ja esta ocupado ou que nao existe
DROP TRIGGER IF EXISTS lugarBilhete;
DELIMITER &&
CREATE TRIGGER lugarBilhete
BEFORE INSERT ON Bilhete
FOR EACH ROW
BEGIN
	DECLARE message VARCHAR(100);
    
    IF((NEW.Lugar IN (SELECT Lugar FROM Bilhete WHERE Sessão_id = NEW.Sessão_id)) OR
		(NEW.Lugar > (SELECT COUNT(l.idLugar) FROM Lugar l, Sessão s
						WHERE l.Nr_Sala = S.Nr_Sala and S.idSessão = NEW.Sessão_id)))
    THEN SET message = 'O lugar não é válido.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message;
    
    END IF;
END &&
DELIMITER &&


-- Impede que seja escolhida uma sala, para a sessao a inserir, que ja esteja ocupada naquela hora
DROP TRIGGER IF EXISTS salaOcupada;
DELIMITER &&
CREATE TRIGGER salaOcupada
BEFORE INSERT ON Sessão
FOR EACH ROW
BEGIN
	DECLARE message VARCHAR(100);
    
    IF(NEW.Nr_Sala IN (SELECT DISTINCT(ss.Nr_Sala) FROM Sessão ss
							WHERE (ss.Data = NEW.Data) AND (NEW.Hora_Início < (ss.Hora_Início + ss.Duração)) AND ((NEW.Hora_Início + NEW.Duração) > ss.Hora_Início)
							GROUP BY ss.Nr_Sala))
    THEN SET message = 'A Sala está ocupada.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message;
    
    END IF;
END &&
DELIMITER &&