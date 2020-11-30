--LISTAR ALUNOS ATIVOS
CREATE VIEW VW_LISTA_ALUNOS_ATIVOS
AS
SELECT 
	cod_matricula AS 'CÓDIGO DE MATRÍCULA',
	nome AS NOME,
	sexo AS SEXO,
	REPLACE(status_aluno, 1, 'ATIVO') AS 'STATUS DO ALUNO'
FROM alunos
WHERE status_aluno = 1


--LISTAR INSTRUTORES ATIVOS
CREATE VIEW VW_LISTA_INSTRUTORES_ATIVOS
AS
SELECT
	cod_instrutor AS 'CÓDIGO INSTRUTOR',
	nome AS 'NOME',
	titulacao AS 'TÍTULO',
	REPLACE(status_instrutor, 1, 'ATIVO') AS 'STATUS INSTRUTOR'
FROM instrutor
WHERE status_instrutor = 1


--VIEW LISTAR TURMAS
CREATE VIEW VW_LISTA_TURMAS
AS 
SELECT
	T.cod_turma AS 'CÓDIGO TURMA',
	T.data_inicial AS 'DATA INÍCIO',
	A.nome AS 'MONITOR',
	I.nome AS 'INSTRUTOR',
	AT.nome AS 'ATIVIDADE',
	convert(varchar(10), HO.horario_inicio, 108) AS 'HORÁRIO INÍCIO',
	convert(varchar(10), HO.horario_fim, 108) AS 'HORÁRIO FIM'
FROM turma AS T
	INNER JOIN alunos AS A
		ON T.fk_alunos_cod_matricula = A.cod_matricula
	INNER JOIN instrutor AS I
		ON T.fk_instrutor_cod_instrutor = I.cod_instrutor
	INNER JOIN horario_atividade AS HA
		ON T.fk_horario_atividade_cod_horario_atividade = HA.cod_horario_atividade
	INNER JOIN ATIVIDADE AS AT
		ON AT.cod_atividade = HA.fk_atividade_cod_atividade
	INNER JOIN HORARIOS AS HO


--VIEW ALUNOS INDIVIDUAIS POR PROFESSOR
CREATE VIEW VW_ALUNOS_INDIVIDUAIS_POR_PROFESSOR
AS
SELECT 
	I.nome AS 'INSTRUTOR',
	COUNT(*) AS 'QUANTIDADE DE AULAS '
FROM 
	treino_individual AS TI
		INNER JOIN instrutor AS I
			ON I.cod_instrutor = TI.fk_instrutor_cod_instrutor
GROUP BY 
	I.nome


-- VIEW LISTA_INSTRUTOR_TELEFONE
CREATE VIEW VW_LISTA_INSTRUTOR_TELEFONE
AS
SELECT 
	I.NOME AS 'NOME INSTRUTOR',
	T.OPERADORA,
	T.DDD,
	T.NUMERO
FROM INSTRUTOR AS I
	INNER JOIN telefone AS T
		ON I.cod_instrutor = T.fk_instrutor_cod_instrutor


--VIEW ALUNOS E PLANOS
CREATE VIEW VW_ALUNOS_PLANOS
AS
SELECT
	A.NOME,
	convert(varchar(10), P.INICIO_PLANO, 103) AS 'ÍNÍCIO DO PLANO',
	P.duracao_plano AS 'DURAÇÃO EM MESES',
	DATEADD(MONTH, P.duracao_plano, P.inicio_plano) AS 'FIM DO PLANO'
FROM ALUNOS AS A
	INNER JOIN PLANOS AS P
		ON A.cod_matricula = P.fk_alunos_cod_matricula


--VIEW LISTA DE RECORDES TODAS AS PESSOAS
CREATE VIEW VW_RECORDES_PESSOAIS
AS
	SELECT 
		A.nome,
		C.descricao AS 'CATEGORIA',
		RP.valor_recorde AS 'RECORDE',
		convert(varchar(10), RP.data, 103) AS 'DATA RECORDE'
	FROM alunos AS A
		INNER JOIN recordes_pessoais AS RP
			ON A.cod_matricula = RP.fk_alunos_cod_matricula
		INNER JOIN categoria AS C
			ON C.cod_cat = RP.fk_categoria_cod_cat


-- VIEW QUANTIDADE RECORDES POR CATEGORIA
CREATE VIEW VW_RECORDES_POR_CATEGORIA
AS
SELECT 
	C.descricao AS CATEGORIA,
	COUNT(*) AS 'QUANTIDADE RECORDES'
FROM CATEGORIA AS C
	INNER JOIN recordes_pessoais AS RP
		ON C.cod_cat = RP.fk_categoria_cod_cat
GROUP BY C.descricao


--VIEW QUANTIDADE DE TURMAS POR ATIVIDADE
CREATE VIEW VW_QUANTIDADE_ATIVIDADES_TURMA
AS
SELECT
	A.nome AS 'ATIVIDADE',
	COUNT(*) AS 'QUANTIDADE DE TURMAS'
FROM HORARIOS AS H
	INNER JOIN horario_atividade AS HR
		ON HR.fk_horarios_cod_horario = H.cod_horario
	INNER JOIN atividade AS A
		ON A.cod_atividade = HR.fk_atividade_cod_atividade
GROUP BY A.nome


--VIEW MEDIA IDADE TODOS ALUNOS
CREATE VIEW VW_MEDIA_IDADE_ALUNOS
AS
SELECT 
	COUNT(*) AS 'QUANTIDADE DE ALUNOS',
	AVG((CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),data_nasc,112))/10000) AS 'MÉDIA DE IDADE'
	--(CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),data_nasc,112))/10000 AS IDADE
FROM 
	alunos


--VIEW Lista atividades academia
CREATE VIEW VW_ATIVIDADES_ACADEMIA
AS
SELECT
	A.nome AS 'ATIVIDADE',
	A.espaco_fisico AS 'ESPAÇO FÍSICO M2',
	convert(varchar(10), H.horario_inicio, 108) AS 'HORÁRIO INÍCIO',
	convert(varchar(10), H.horario_fim, 108) AS 'HORÁRIO FIM'
FROM HORARIOS AS H
	INNER JOIN horario_atividade AS HR
		ON HR.fk_horarios_cod_horario = H.cod_horario
	INNER JOIN atividade AS A
		ON A.cod_atividade = HR.fk_atividade_cod_atividade


--VIEW REGISTROS
CREATE VIEW VW_LISTA_REGISTROS
AS
SELECT 
	convert(varchar(10), DATA, 103) AS 'DATA ALTERAÇÃO',
	convert(varchar(10), DATA, 108) AS 'HORA ALTERAÇÃO',
	entidade_atualizada as 'ENTIDADE MODIFICADA'
 FROM TRIGGER_REGISTROS


--VIEW QUANTIDADE ALUNOS POR DIA DA SEMANA
CREATE VIEW VW_QUANTIDADE_ALUNOS_WEEKDAY
AS
SELECT 
	DATENAME(WEEKDAY, DATA_AULA) 'DIA SEMANA',
	COUNT(*) 'QUANTIDADE ALUNOS'
FROM 
	TURMA_ALUNO
WHERE 
	DATEPART(MONTH, DATA_AULA) = 11
GROUP BY
	DATENAME(WEEKDAY, DATA_AULA)
