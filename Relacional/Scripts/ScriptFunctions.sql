Use Cinema;

-- ----------------------------- FUNCTIONS -----------------------------

-- Funcao que calcula o preço do bilhete para um determinado tipo de cliente;
DROP FUNCTION IF EXISTS calcula_preco;
DELIMITER &&
CREATE FUNCTION calcula_preco (n INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
	DECLARE preco DECIMAL(3,2);
    IF('N' = (SELECT C.Tipo FROM Cliente AS C WHERE C.NIF = n))
		THEN SET preco = 4.60;
		ELSE SET preco = 3.45;
    END IF;
    
    RETURN (preco);
    
END &&
DELIMITER &&


-- Funcao que calcula o id do proximo bilhete a inserir
DROP FUNCTION IF EXISTS calcula_idBilhete;
DELIMITER &&
CREATE FUNCTION calcula_idBilhete ()
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE id INT;
    
    SET id = (SELECT COUNT(*) FROM Bilhete) + 1;
    
    RETURN (id);
    
END &&
DELIMITER &&


-- Funcao que calcula o id da proxima sessao a inserir
DROP FUNCTION IF EXISTS calcula_idSessão;
DELIMITER &&
CREATE FUNCTION calcula_idSessão ()
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE id INT;
    
    SET id = (SELECT COUNT(*) FROM Sessão) + 1;
    
    RETURN (id);
    
END &&
DELIMITER &&