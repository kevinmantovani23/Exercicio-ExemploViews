CREATE DATABASE fac_palestras
USE fac_palestras

CREATE TABLE curso (
	codigo_curso	INT		NOT NULL,
	nome			VARCHAR(70) NOT NULL,
	sigla			VARCHAR(10) NOT NULL,
	PRIMARY KEY(codigo_curso)
)

CREATE TABLE aluno (
	ra			CHAR(7)		NOT NULL,
	nome		VARCHAR(250) NOT NULL,
	codigo_curso	INT		NOT NULL,
	FOREIGN KEY (codigo_curso) REFERENCES curso(codigo_curso),
	PRIMARY KEY(ra)
)

CREATE TABLE palestrante (
	codigo_palestrante	INT		IDENTITY,
	nome		VARCHAR(250)	NOT NULL,
	empresa		VARCHAR(100)	NOT NULL,
	PRIMARY KEY (codigo_palestrante)
)

CREATE TABLE palestra (
	codigo_palestra		INT		IDENTITY,
	titulo			VARCHAR(MAX)	NOT NULL,
	carga_horaria	INT		NULL,
	data		DATETIME		NOT NULL,
	codigo_palestrante		INT NOT NULL,
	FOREIGN KEY (codigo_palestrante) REFERENCES palestrante(codigo_palestrante),
	PRIMARY KEY (codigo_palestra)
)

CREATE TABLE alunos_inscritos (
	ra		CHAR(7)		NOT NULL,
	codigo_palestra		INT		NOT NULL
	FOREIGN KEY (ra) REFERENCES  aluno(ra),
	FOREIGN KEY (codigo_palestra) REFERENCES palestra(codigo_palestra),
	PRIMARY KEY(ra, codigo_palestra)
)

CREATE TABLE nao_alunos (
	rg		VARCHAR(9)	NOT NULL,
	orgao_exp CHAR(5)	NOT NULL,
	nome	VARCHAR(250) NOT NULL,
	PRIMARY KEY(rg, orgao_exp)
)

CREATE TABLE nao_alunos_inscritos (
	codigo_palestra		INT		NOT NULL,
	rg					VARCHAR(9) NOT NULL,
	orgao_exp			CHAR(5)  NOT NULL,
	FOREIGN KEY (codigo_palestra) REFERENCES palestra(codigo_palestra),
	FOREIGN KEY (rg, orgao_exp) REFERENCES nao_alunos(rg, orgao_exp),
	PRIMARY KEY (codigo_palestra, rg, orgao_exp)
)

CREATE VIEW view_participantes
AS
	SELECT a.ra as num_documento, a.nome as nome_pessoa, ai.codigo_palestra
	FROM aluno a
	RIGHT OUTER JOIN alunos_inscritos ai ON
	a.ra = ai.ra
	UNION
	SELECT na.rg + ' - ' + na.orgao_exp as num_documento, na.nome as nome_pessoa, nai.codigo_palestra
	FROM nao_alunos na
	RIGHT OUTER JOIN nao_alunos_inscritos nai ON
	na.rg = nai.rg AND na.orgao_exp = nai.orgao_exp

CREATE VIEW view_palestra
AS
	SELECT pa.codigo_palestra, par.num_documento, par.nome_pessoa, pa.titulo as titulo_palestra, pal.nome as nome_palestrante, pa.carga_horaria,
	data
	FROM palestra pa, view_participantes par, palestrante pal
	WHERE pa.codigo_palestra = par.codigo_palestra AND
		  pal.codigo_palestrante = pa.codigo_palestrante

SELECT num_documento, nome_pessoa, titulo_palestra, nome_palestrante, carga_horaria, data FROM view_palestra
WHERE codigo_palestra = 43
ORDER BY nome_pessoa


