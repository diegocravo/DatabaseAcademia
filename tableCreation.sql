CREATE DATABASE academia_400;
USE academia_400;

CREATE TABLE instrutor
(
    cod_instrutor int IDENTITY,
    nome varchar(50) NOT NULL,
    titulacao VARCHAR(25) NOT NULL,
    rg VARCHAR(20) NOT NULL,
    data_nascimento date NOT NULL,
    status_instrutor CHAR NOT NULL,
    PRIMARY KEY (cod_instrutor)
);

CREATE TABLE telefone
(
    cod_telefone int IDENTITY,
    fk_instrutor_cod_instrutor int NOT NULL,
    ddd int NOT NULL,
    numero int NOT NULL,
    operadora int,
    PRIMARY KEY (cod_telefone),
    FOREIGN KEY (fk_instrutor_cod_instrutor) REFERENCES instrutor(cod_instrutor)
);

CREATE TABLE alunos
(
    cod_matricula int NOT NULL PRIMARY KEY IDENTITY,
    cpf char(11) NOT NULL UNIQUE,
    nome varchar(60) NOT NULL,
    endereco varchar(60) NOT NULL,
    telefone varchar(15) NULL,
    data_nasc date NOT NULL,
    data_matricula date NOT NULL,
    sexo char(1) NOT NULL,
    status_aluno CHAR NOT NULL
);

CREATE TABLE treino_individual
(
    cod_treino int IDENTITY,
    fk_instrutor_cod_instrutor int NOT NULL,
    fk_alunos_cod_matricula int NOT NULL,
    categoria_treino varchar(15) NOT NULL,
    descricao varchar(50) NOT NULL,
    data datetime NOT NULL,
    PRIMARY KEY (cod_treino),
    FOREIGN KEY (fk_instrutor_cod_instrutor) REFERENCES instrutor(cod_instrutor),
    FOREIGN KEY (fk_alunos_cod_matricula) REFERENCES alunos(cod_matricula)
);

CREATE TABLE horarios
(
    cod_horario int IDENTITY,
    horario_inicio time NOT NULL,
    horario_fim time NOT NULL,
    PRIMARY KEY (cod_horario)
);

CREATE TABLE atividade
(
    cod_atividade int NOT NULL PRIMARY KEY IDENTITY,
    espaco_fisico decimal,
    nome varchar(50) NOT NULL
);

CREATE TABLE horario_atividade
(
    cod_horario_atividade int PRIMARY KEY IDENTITY,
    fk_horarios_cod_horario int FOREIGN KEY REFERENCES horarios(cod_horario),
    fk_atividade_cod_atividade int FOREIGN KEY REFERENCES atividade(cod_atividade)
);

CREATE TABLE turma
(
    cod_turma int PRIMARY KEY IDENTITY,
    cap_max int NOT NULL,
    data_inicial date NOT NULL,
    data_final date NOT NULL,
    fk_horario_atividade_cod_horario_atividade int FOREIGN KEY REFERENCES horario_atividade(cod_horario_atividade),
    fk_instrutor_cod_instrutor int FOREIGN KEY REFERENCES instrutor(cod_instrutor),
    fk_alunos_cod_matricula int FOREIGN KEY REFERENCES alunos(cod_matricula)
);

CREATE TABLE turma_aluno
(
    cod_turma_aluno int NOT NULL PRIMARY KEY IDENTITY,
    pontuacao decimal(2) NULL,
    data_aula date NOT NULL,
    fk_turma_cod_turma int FOREIGN KEY REFERENCES turma(cod_turma),
    fk_alunos_cod_matricula int FOREIGN KEY REFERENCES alunos(cod_matricula)
);

CREATE TABLE categoria
(
    cod_cat int PRIMARY KEY IDENTITY,
    descricao varchar(50) NOT NULL
);

CREATE TABLE recordes_pessoais
(
    cod_rp int PRIMARY KEY IDENTITY,
    valor_recorde varchar(20) NOT NULL,
    exercicio varchar(30) NOT NULL,
    data date NOT NULL,
    fk_alunos_cod_matricula int,
    fk_categoria_cod_cat int,
    FOREIGN KEY (fk_alunos_cod_matricula) REFERENCES alunos(cod_matricula),
    FOREIGN KEY (fk_categoria_cod_cat) REFERENCES categoria(cod_cat)
);

CREATE TABLE nutricionista
(
    COD_NUTRI int NOT NULL PRIMARY KEY IDENTITY,
    DATA_NASC date NOT NULL,
    NOME varchar(50) NOT NULL,
    status_nutricionista CHAR NOT NULL,
    CRN char(15) NOT NULL
);

CREATE TABLE avaliacao_fisica
(
    cod_avaliacao_fisica INT NOT NULL PRIMARY KEY IDENTITY,
    peso decimal(5,2) NOT NULL,
    altura decimal(5,2) NOT NULL,
    percentual_gordura decimal(5,2) NOT NULL,
    objetivo VARCHAR(100) NOT NULL,
    avaliacao_postura VARCHAR(100) NOT NULL,
    avaliacao_neuromotora VARCHAR(100) NOT NULL,
    fk_alunos_cod_matricula INT FOREIGN KEY REFERENCES alunos(cod_matricula),
    fk_instrutor_cod_instrutor INT FOREIGN KEY REFERENCES instrutor(COD_INSTRUTOR)
);

CREATE TABLE avaliacao_nutricional
(
    cod_avaliacao_nutricional INT NOT NULL PRIMARY KEY IDENTITY,
    peso decimal(5,2) NOT NULL,
    altura decimal(5,2) NOT NULL,
    percentual_gordura decimal(5,2) NOT NULL,
    objetivo VARCHAR(100) NOT NULL,
    TMB VARCHAR(100) NOT NULL,
    avaliacao_dietetica VARCHAR(100) NOT NULL,
    fk_alunos_cod_matricula INT FOREIGN KEY REFERENCES alunos(cod_matricula),
    fk_nutricionista_cod_nutri INT FOREIGN KEY REFERENCES nutricionista(COD_NUTRI)
);

CREATE TABLE planos
(
    cod_planos INT NOT NULL PRIMARY KEY IDENTITY,
    inicio_plano DATE NOT NULL,
    duracao_plano TINYINT NOT NULL,
    fk_alunos_cod_matricula INT FOREIGN KEY REFERENCES alunos(cod_matricula)
);

CREATE TABLE solicitacao_treino
(
    cod_solitacao INT NOT NULL PRIMARY KEY IDENTITY,
    tipo_treino VARCHAR(25) NOT NULL,
    data_treino DATE NOT NULL,
    hora_treino TIME NOT NULL,
    instrutor VARCHAR(25),
    fk_alunos_cod_matricula INT FOREIGN KEY REFERENCES alunos(cod_matricula),
    fk_instrutor_cod_instrutor INT FOREIGN KEY REFERENCES instrutor(COD_INSTRUTOR)
);

CREATE TABLE solicitar_avaliacao
(
    cod_requisicao INT NOT NULL PRIMARY KEY IDENTITY,
    tipo_avaliacao VARCHAR(25) NOT NULL,
    data_avaliacao DATE NOT NULL,
    hora_avaliacao TIME NOT NULL,
    avaliador VARCHAR(25),
    fk_alunos_cod_matricula INT FOREIGN KEY REFERENCES alunos(cod_matricula),
    fk_nutricionista_cod_nutri INT FOREIGN KEY REFERENCES nutricionista(COD_NUTRI),
    fk_instrutor_cod_instrutor INT FOREIGN KEY REFERENCES instrutor(COD_INSTRUTOR)
);
 
