Use cinema;

-- ----------------------------- QUERIES -----------------------------

-- Lista de Clientes Ordenada pelo numero de bilhetes comprados
SELECT C.Nome, COUNT(B.idBilhete) FROM Cliente AS C
	INNER JOIN Bilhete AS B ON C.NIF = B.Cliente_NIF
    GROUP BY C.NIF
    ORDER BY COUNT(B.idBilhete) DESC;


-- Lista de filmes em exibição numa determinada data
SELECT F.idFilme, F.Nome, S.Data, S.Hora_Início, S.Nr_Sala FROM Filme AS F
	INNER JOIN Sessão AS S ON F.idFilme = S.Filme_id
    WHERE S.Data = '20181121'
    ORDER BY S.Hora_Início;


-- Lista de sessões para um determinado filme numa determinada data
SELECT S.idSessão, S.Hora_Início, F.Nome FROM Sessão AS S
	INNER JOIN Filme AS F ON S.Filme_id = F.idFilme
    WHERE F.Nome = 'Venom' AND S.Data = '20181122';


-- Lista de lugares disponíveis para uma determinada sessão
SELECT ls.idLugar, ls.Número_Cadeira, ls.Fila FROM
	(SELECT l.idLugar, l.Número_Cadeira, l.Fila FROM Lugar l, Sessão s
		WHERE l.Nr_Sala = S.Nr_Sala and S.idSessão = 1) AS ls
			LEFT JOIN (SELECT b.Lugar FROM Bilhete b
							WHERE b.Sessão_id = 1) AS lb
								ON ls.idLugar = lb.Lugar
				WHERE lb.Lugar IS null;


-- Numero da sala de uma determinada sessao
SELECT S.Nr_Sala FROM Sessão AS S
	WHERE S.idSessão = 1;


-- Hora de uma sessão
SELECT S.Hora_Início FROM Sessão AS S
	WHERE S.idSessão = 1;


-- O número de bilhetes que ainda restam para uma sessão
SELECT COUNT(ls.idLugar) FROM
	(SELECT l.idLugar FROM Lugar l, Sessão s
		WHERE l.Nr_Sala = S.Nr_Sala and S.idSessão = 1) AS ls
			LEFT JOIN (SELECT b.Lugar FROM Bilhete b
							WHERE b.Sessão_id = 1) AS lb
								ON ls.idLugar = lb.Lugar
				WHERE lb.Lugar IS null;


-- Lista de salas disponíveis numa determinada data/hora;
SELECT s.Número_Sala FROM Sala s 
    LEFT JOIN (SELECT DISTINCT(ss.Nr_Sala) FROM Sessão ss
					WHERE (ss.Data = '20181122') AND ((ss.Hora_Início  BETWEEN '17:00:00' AND '19:00:00')
												OR (ss.Hora_Início+ss.Duração BETWEEN '17:00:00' AND '19:00:00')
                                                OR (ss.Hora_Início+(ss.Duração/2) BETWEEN '17:00:00' AND '19:00:00'))
                    GROUP BY ss.Nr_Sala) AS tSessao
						ON s.Número_Sala=tSessao.Nr_Sala
							WHERE tSessao.Nr_Sala IS null;


-- Nome do funcionário que registou um determinado bilhete
SELECT F.idFuncionário, F.Nome FROM Funcionário AS F
	INNER JOIN Bilhete AS B ON F.idFuncionário = B.Funcionário_id
		WHERE B.idBilhete = 2;


-- Lista de funcionarios que venderam mais bilhetes
SELECT F.idFuncionário, F.Nome, COUNT(B.Funcionário_id) FROM Funcionário AS F
	INNER JOIN Bilhete AS B ON F.idFuncionário = B.Funcionário_id
		GROUP BY F.idFuncionário
		ORDER BY COUNT(B.Funcionário_id) DESC;


-- Quantos bilhetes um determinado tipo de cliente comprou num determinado intervalo de datas;
SELECT COUNT(B.Cliente_NIF) FROM Bilhete AS B
	INNER JOIN Cliente AS C ON B.Cliente_NIF = C.NIF
		WHERE C.Tipo = 'E' AND (B.Data_Emissão BETWEEN '20181120' AND '20181121');


-- Lista de sessões com mais bilhetes vendidos num determinado intervalo de datas
SELECT S.idSessão, F.Nome, S.Data, S.Hora_Início, COUNT(B.Sessão_id) FROM Sessão AS S
	INNER JOIN Filme AS F ON S.Filme_id = F.idFilme
		INNER JOIN Bilhete AS B ON S.idSessão = B.Sessão_id
			WHERE S.Data BETWEEN '20181120' AND '20181121'
			GROUP BY S.idSessão
            ORDER BY COUNT(B.Sessão_id) DESC;


-- Número de bilhetes vendidos num determinado dia ou intervalo de datas;
SELECT COUNT(b.idBilhete) FROM Bilhete b
    WHERE b.Data_Emissão BETWEEN '20181120' AND '20181121';


-- Numero de bilhetes que foram vendidos num determinado dia
SELECT COUNT(B.Data_Emissão) FROM Bilhete AS B
	WHERE B.Data_Emissão = '20181121';


-- Lista de filmes em exibiçao com melhores classificaçoes, top3
SELECT F.idFilme, F.Nome, F.Classificação, S.Data FROM Filme AS F
	INNER JOIN Sessão AS S ON F.idFilme = S.Filme_id
    WHERE S.Data = '20181125'
    ORDER BY F.Classificação DESC
    LIMIT 3;


-- Lista dos 10 filmes mais vistos no cinema.
SELECT F.idFilme, F.Nome, COUNT(B.Sessão_id) FROM Filme AS F
	INNER JOIN Sessão AS S ON F.idFilme = S.Filme_id
		INNER JOIN Bilhete AS B ON S.idSessão = B.Sessão_id
        GROUP BY F.idFilme
        ORDER BY COUNT(B.Sessão_id) DESC
        LIMIT 10;