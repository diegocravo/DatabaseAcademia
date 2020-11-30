
--FUNCTION CALCULAR IDADE ALUNO || ESCALAR
CREATE FUNCTION uFN_IDADE
(@DATA_NASC DATE)
RETURNS INT
AS
BEGIN
    DECLARE @IDADE INT
    --SET @IDADE = (CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@DATA_NASC ,112)/10000)
    SET @IDADE = DATEDIFF(YEAR, @DATA_NASC, CONVERT(DATE, GETDATE()))
    RETURN @IDADE
END


--MEDIA IDADE TURMA
CREATE FUNCTION uFN_MEDIA_IDADE_TURMA
(@COD_TURMA INT)
RETURNS INT
AS
BEGIN
    DECLARE @MEDIA INT
    SET @MEDIA = (
		select
        AVG(dbo.uFN_IDADE(data_nasc)) AS 'MEDIA IDADE TURMA'
    FROM alunos AS A
        INNER JOIN turma_aluno AS TA
        ON A.cod_matricula = TA.fk_alunos_cod_matricula
        INNER JOIN turma AS T
        ON T.cod_turma = TA.fk_turma_cod_turma
    WHERE 
			T.cod_turma = @COD_TURMA
				)
    RETURN @MEDIA
END


--FUNCTION IDADE TODAS AS TURMAS
CREATE FUNCTION uFN_MEDIA_IDADE_TODAS_TURMAS
()
RETURNS TABLE
AS 
RETURN
(
select
    T.cod_turma AS 'CÓDIGO TURMA',
    AT.nome AS 'ATIVIDADE',
    AVG(dbo.uFN_IDADE(data_nasc)) AS 'MEDIA IDADE TURMA',
    COUNT(*) AS 'QUANTIDADE ALUNOS',
    CONVERT(varchar(10), H.horario_inicio, 108) AS 'HORÁRIO INÍCIO',
    CONVERT(varchar(10), H.horario_fim, 108) AS 'HORÁRIO FIM'
FROM turma_aluno AS TA
    INNER JOIN alunos AS A
    ON A.cod_matricula = TA.fk_alunos_cod_matricula
    INNER JOIN turma AS T
    ON T.cod_turma = TA.fk_turma_cod_turma
    INNER JOIN horario_atividade AS HA
    ON T.fk_horario_atividade_cod_horario_atividade = HA.cod_horario_atividade
    INNER JOIN ATIVIDADE AS AT
    ON AT.cod_atividade = HA.fk_atividade_cod_atividade
    INNER JOIN horarios AS H
    ON H.cod_horario = HA.fk_horarios_cod_horario
GROUP BY 
	T.cod_turma, AT.nome, H.horario_inicio, H.horario_fim
)


-- FUNCTION QUANTIDADE CHECKIN ALUNOS
-- TODAS AS TURMAS E TODAS AS ATIVIDADES
CREATE FUNCTION SP_CHECKIN_TODOS_ALUNOS
()
RETURNS TABLE
AS
RETURN(
SELECT
    A.nome AS NOME,
    COUNT(*) AS CHECKIN
FROM
    turma_aluno AS TA
    INNER JOIN alunos AS A
    ON A.cod_matricula = TA.fk_alunos_cod_matricula
GROUP BY
	A.nome
)


-- FUNCTION QUANTIDADE CHECKIN ALUNOS
-- DE UMA DETERMINADA TURMA
CREATE FUNCTION SP_CHECKIN_ALUNO_TURMA
(@TURMA INT)
RETURNS TABLE
AS
RETURN(
	SELECT
    A.nome AS NOME,
    COUNT(*) AS CHECKIN
FROM
    turma_aluno AS TA
    INNER JOIN alunos AS A
    ON A.cod_matricula = TA.fk_alunos_cod_matricula
    INNER JOIN turma AS T
    ON T.cod_turma = TA.fk_turma_cod_turma
WHERE
		cod_turma = @TURMA
GROUP BY
		A.nome
)

--CREATE FUNCTION QUANTIDADE CHECKIN ALUNO EM UMA ATIVIDADE
CREATE FUNCTION SP_CHECKIN_ALUNO_ATIVIDADE
(@COD_ATIVIDADE INT)
RETURNS TABLE
AS
RETURN(
	SELECT
    A.nome AS NOME,
    COUNT(*) AS CHECKIN
FROM
    turma_aluno AS TA
    INNER JOIN alunos AS A
    ON A.cod_matricula = TA.fk_alunos_cod_matricula
    INNER JOIN turma AS T
    ON T.cod_turma = TA.fk_turma_cod_turma
    INNER JOIN horario_atividade AS HA
    ON T.fk_horario_atividade_cod_horario_atividade = HA.cod_horario_atividade
    INNER JOIN atividade AS AT
    ON AT.cod_atividade = HA.fk_atividade_cod_atividade
WHERE
		AT.cod_atividade = @COD_ATIVIDADE
GROUP BY
		A.nome
)
