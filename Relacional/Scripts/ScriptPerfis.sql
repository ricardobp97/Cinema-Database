Use Cinema;

-- Criacao de um administrador
DROP USER IF EXISTS 'admin'@'localhost';
CREATE USER 'admin'@'localhost';
	SET PASSWORD FOR 'admin'@'localhost' = 'adminpass';


-- Criacao de funcionarios
DROP USER IF EXISTS 'func1'@'localhost';
CREATE USER 'func1'@'localhost';
	SET PASSWORD FOR 'func1'@'localhost' = 'func1pass';

DROP USER IF EXISTS 'func2'@'localhost';    
CREATE USER 'func2'@'localhost';
	SET PASSWORD FOR 'func2'@'localhost' = 'func2pass';

DROP USER IF EXISTS 'func3'@'localhost';    
CREATE USER 'func3'@'localhost';
	SET PASSWORD FOR 'func3'@'localhost' = 'func3pass';

DROP USER IF EXISTS 'func4'@'localhost';        
CREATE USER 'func4'@'localhost';
	SET PASSWORD FOR 'func4'@'localhost' = 'func4pass';

SELECT user FROM mysql.user;


/* Permissões de admin
Consultar e inserir:
	- Bilhete;
    - Cliente;
	- Sala;
    - Lugar;
    - Sessão;
    - Filme.
*/
 
GRANT SELECT, INSERT, DELETE, UPDATE ON Cinema.* TO 'admin'@'localhost' 
	WITH GRANT OPTION;

-- WITH GRANT OPTION - Não sei se deveremos colocar isto. Deve ser usado com precaução, visto 
-- que isto permite que este usuário dê permissões a outros usuários.

SHOW GRANTS FOR 'admin'@'localhost';

/*
Permissões de funcionários
Consultar e inserir:
	- Bilhete;
    - Cliente
Apenas consulta:
	- Sala;
    - Lugar;
    - Sessão;
    - Filme;
Sem acesso:
	- Funcionario
*/

GRANT SELECT, INSERT, DELETE, UPDATE ON Cinema.Bilhete TO 'func1'@'localhost',
														  'func2'@'localhost',
												          'func3'@'localhost',
												          'func4'@'localhost';
                                                          
                                                           
GRANT SELECT, INSERT, DELETE, UPDATE ON Cinema.Cliente TO 'func1'@'localhost',
												  'func2'@'localhost',
												  'func3'@'localhost',
												  'func4'@'localhost';
                                                  
                                                           
GRANT SELECT ON Cinema.Sala TO 'func1'@'localhost',
							   'func2'@'localhost',
							   'func3'@'localhost',
							   'func4'@'localhost'; 
                               
REVOKE INSERT, DELETE, UPDATE ON Cinema.Sala FROM 'func1'@'localhost',
												  'func2'@'localhost',
												  'func3'@'localhost',
												  'func4'@'localhost'; 
                               
                               
GRANT SELECT ON Cinema.Lugar TO 'func1'@'localhost',
								'func2'@'localhost',
							    'func3'@'localhost',
							    'func4'@'localhost';
                                
REVOKE INSERT, DELETE, UPDATE ON Cinema.Lugar FROM 'func1'@'localhost',
												   'func2'@'localhost',
												   'func3'@'localhost',
												   'func4'@'localhost'; 
                                                  
                                
GRANT SELECT ON Cinema.Sessão TO 'func1'@'localhost',
							     'func2'@'localhost',
							     'func3'@'localhost',
							     'func4'@'localhost'; 
                               
REVOKE INSERT, DELETE, UPDATE ON Cinema.Sessão FROM 'func1'@'localhost',
												    'func2'@'localhost',
												    'func3'@'localhost',
												    'func4'@'localhost'; 








SELECT user FROM mysql.user;
SHOW GRANTS FOR 'func1'@'localhost';


FLUSH PRIVILEGES;

