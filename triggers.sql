-- TRIGGER ALUNOS
CREATE TRIGGER uTR_SAVE_CHANGES
ON alunos
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    INSERT INTO TRIGGER_REGISTROS
        (data, entidade_atualizada)
    VALUES
        (GETDATE(), 'ALUNOS')
END


--TRIGGER INSTRUTOR
CREATE TRIGGER uTR_SAVE_CHANGES_INSTRUTOR
ON instrutor
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    INSERT INTO TRIGGER_REGISTROS
        (data, entidade_atualizada)
    VALUES
        (GETDATE(), 'INSTRUTOR')
END


--TRIGGER TURMA
CREATE TRIGGER uTR_SAVE_CHANGES_TURMA
ON turma
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    INSERT INTO TRIGGER_REGISTROS
        (data, entidade_atualizada)
    VALUES
        (GETDATE(), 'TURMA')
END


--TRIGGER NUTRICIONISTA
CREATE TRIGGER uTR_SAVE_CHANGES_NUTRICIONISTA
ON NUTRICIONISTA
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    INSERT INTO TRIGGER_REGISTROS
        (data, entidade_atualizada)
    VALUES
        (GETDATE(), 'NUTRICIONISTA')
END

-- TRIGGER INSERIR ALUNO
CREATE TRIGGER TR_MATRICULA_TURMA
ON turma_aluno
FOR insert
as
begin
    declare @cod_turma int
    declare @cap_max int
    declare @qtd_aluno_turma int

    set @cod_turma = (select fk_turma_cod_turma
    from inserted)
    set @cap_max = (select cap_max
    from turma
    where cod_turma = @cod_turma)
    set @qtd_aluno_turma = (
		select
        count(ta.fk_alunos_cod_matricula)
    from
        turma as t
        inner join turma_aluno as ta
        on t.cod_turma = ta.fk_turma_cod_turma
    where 
			cod_turma = @cod_turma
		)

    if(@cap_max < @qtd_aluno_turma)
		begin
        insert into turma_aluno
            (pontuacao, fk_turma_cod_turma, fk_alunos_cod_matricula, data_aula)
        select
            pontuacao, fk_turma_cod_turma, fk_alunos_cod_matricula, data_aula
        from
            inserted
        PRINT('ALUNO INSERIDO COM SUCESSO')
    end
	else IF(@cap_max >= @qtd_aluno_turma)
		BEGIN
        print('A TURMA ATINGIU A CAPACIDADE MÁXIMA, ENTRE EM CONTATO COM A ADMINISTRAÇÃO')
    END

end
