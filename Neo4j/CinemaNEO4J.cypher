------------------- Cliente -------------------
LOAD CSV WITH HEADERS FROM 'file:///Cliente.csv' AS row
CREATE (cliente: Cliente {NIF: toInteger(row.NIF)})
SET cliente.Nome = toString(row.Nome),
	cliente.Tipo = toString(row.Tipo)
RETURN cliente;

------------------- Funcionário -------------------
LOAD CSV WITH HEADERS FROM 'file:///Funcionario.csv' AS row
CREATE (funcionario: Funcionario {idFuncionario: toInteger(row.idFuncionario)})
SET funcionario.Nome = toString(row.Nome),
RETURN funcionario;

------------------- Filme -------------------
LOAD CSV WITH HEADERS FROM 'file:///Filme.csv' AS row
CREATE (filme: Filme {idFilme: toInteger(row.idFilme)})
SET filme.Nome = toString(row.Nome),
	filme.Descricao = toString(row.Descricao),
	filme.Classificacao = toFloat(row.Classificacao)
RETURN filme;

------------------- Bilhete -------------------
LOAD CSV WITH HEADERS FROM 'file:///Bilhete.csv' AS row
CREATE (bilhete: Bilhete {idBilhete: toInteger(row.idBilhete)})
SET bilhete.Data_Emissao = toString(row.Data_Emissao),
	bilhete.Lugar = toInteger(row.Lugar),
	bilhete.Preco = toFloat(row.Preco)
RETURN bilhete;

------------------- Lugar -------------------
LOAD CSV WITH HEADERS FROM 'file:///Lugar.csv' AS row
CREATE (lugar: Lugar {idLugar: toInteger(row.idLugar)})
SET lugar.Nr_Sala = toInteger(row.Nr_Sala),
	lugar.Numero_Cadeira = toInteger(row.Numero_Cadeira),
	lugar.Fila = toString(row.Fila)
RETURN lugar;

------------------- Sala -------------------
LOAD CSV WITH HEADERS FROM 'file:///Sala.csv' AS row
CREATE (sala: Sala {Numero_Sala: toInteger(row.Numero_Sala)})
RETURN sala;

------------------- Sessão -------------------
LOAD CSV WITH HEADERS FROM 'file:///Sessao.csv' AS row
CREATE (sessao: Sessao {idSessao: toInteger(row.idSessao)})
SET sessao.Preco_Base = toFloat(row.Preco_Base),
	sessao.Data = toString(row.Data),
	sessao.Hora_Inicio = toString(row.Hora_Inicio),
	sessao.Duracao = toString(row.Duracao)
RETURN sessao;

------------------------- Sala - [:TEM_LUGAR] -> Lugar -------------------------
MATCH (l: Lugar),(s: Sala)
WHERE l.Nr_Sala = s.Numero_Sala
CREATE (s)-[:TEM_LUGAR]->(l);

------------------------- Sala - [:REALIZA_SESSAO] -> Sessao -------------------------
LOAD CSV WITH HEADERS FROM 'file:///Sessao.csv' AS row
MATCH (s: Sala {Numero_Sala: toInteger(row.Nr_Sala)})
MATCH (se: Sessao {idSessao : toInteger(row.idSessao)})
CREATE (s)-[:REALIZA_SESSAO]->(se);

------------------------- Sessao - [:EXIBE_FILME] -> Filme -------------------------
LOAD CSV WITH HEADERS FROM 'file:///Sessao.csv' AS row
MATCH (f: Filme {idFilme: toInteger(row.Filme_id)})
MATCH (s: Sessao {idSessao : toInteger(row.idSessao)})
CREATE (s)-[:EXIBE_FILME]->(f);

------------------------- Cliente - [:COMPRA] -> Bilhete -------------------------
LOAD CSV WITH HEADERS FROM 'file:///Bilhete.csv' AS row
MATCH (c: Cliente {NIF: toInteger(row.Cliente_NIF)})
MATCH (b: Bilhete {idBilhete: toInteger(row.idBilhete)})
CREATE (c)-[:COMPRA]->(b);

------------------------- Funcionario - [:REGISTA] -> Bilhete -------------------------
LOAD CSV WITH HEADERS FROM 'file:///Bilhete.csv' AS row
MATCH (f: Funcionario {idFuncionario: toInteger(row.Funcionario_id)})
MATCH (b: Bilhete {idBilhete: toInteger(row.idBilhete)})
CREATE (f)-[:REGISTA]->(b);

------------------------- Sessao - [:TEM] -> Bilhete -------------------------
LOAD CSV WITH HEADERS FROM 'file:///Bilhete.csv' AS row
MATCH (s: Sessao {idSessao: toInteger(row.Sessao_id)})
MATCH (b: Bilhete {idBilhete: toInteger(row.idBilhete)})
CREATE (s)-[:TEM]->(b);


----------------------------- QUERYS ----------------------------------

-- Lista de Clientes Ordenada pelo numero de bilhetes comprados
MATCH (c:Cliente)-[:COMPRA]->(b:Bilhete)
RETURN c.Nome, COUNT(b)
ORDER BY COUNT(b) DESC;

-- Lista de filmes em exibição numa determinada data
MATCH (sa:Sala)-[:REALIZA_SESSAO]->(s:Sessao)-[:EXIBE_FILME]->(f:Filme)
WHERE s.Data = '2018-11-21'
RETURN f.idFilme, f.Nome, s.Data, s.Hora_Inicio, sa.Numero_Sala
ORDER BY s.Hora_Inicio;

-- Lista de sessões para um determinado filme numa determinada data
MATCH (s:Sessao)-[:EXIBE_FILME]->(f:Filme)
WHERE s.Data = '2018-11-22' AND f.Nome = 'Venom'
RETURN s.idSessao, s.Hora_Inicio, f.Nome;

-- Numero da sala de uma determinada sessao
MATCH (sa:Sala)-[:REALIZA_SESSAO]->(s:Sessao)
WHERE s.idSessao = 1
RETURN sa.Numero_Sala

-- Hora de uma sessão
MATCH (s:Sessao)
WHERE s.idSessao = 1
RETURN s.Hora_Inicio

-- Lista de funcionarios que venderam mais bilhetes
MATCH (f:Funcionario)-[:REGISTA]->(b:Bilhete)
RETURN f.Nome, COUNT(b)
ORDER BY COUNT(b) DESC

-- Nome do funcionário que registou um determinado bilhete
MATCH (f:Funcionario)-[:REGISTA]->(b:Bilhete)
WHERE b.idBilhete = 2
RETURN f.Nome

-- Quantos bilhetes um determinado tipo de cliente comprou num determinado intervalo de datas
MATCH (c:Cliente {Tipo: 'E'})-[:COMPRA]->(b:Bilhete)
WHERE b.Data_Emissao >= '2018-11-20' AND b.Data_Emissao < '2018-11-22'
RETURN COUNT(b)

-- Lista de sessões com mais bilhetes vendidos num determinado intervalo de datas
MATCH (f:Filme)<-[:EXIBE_FILME]-(s:Sessao)-[:TEM]->(b:Bilhete)
WHERE s.Data >= '2018-11-20' AND s.Data <= '2018-11-21'
RETURN s.idSessao, f.Nome, s.Data, s.Hora_Inicio, COUNT(b)
ORDER BY COUNT(b) DESC

-- Número de bilhetes vendidos num determinado dia ou intervalo de datas
MATCH (b:Bilhete)
WHERE b.Data_Emissao >= '2018-11-20' AND b.Data_Emissao <= '2018-11-21'
RETURN COUNT(b)

-- Lista de filmes em exibiçao com melhores classificaçoes, top3
MATCH (s:Sessao {Data: '2018-11-25'})-[:EXIBE_FILME]->(f:Filme)
RETURN f.idFilme, f.Nome, f.Classificacao, s.Data
ORDER BY f.Classificacao DESC
LIMIT 3

-- Lista dos 10 filmes mais vistos no cinema
MATCH (f:Filme)<-[:EXIBE_FILME]-(s:Sessao)-[:TEM]->(b:Bilhete)
RETURN f.idFilme, f.Nome, COUNT(b)
ORDER BY COUNT(b) DESC
LIMIT 10