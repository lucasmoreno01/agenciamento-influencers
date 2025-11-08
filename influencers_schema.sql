
---

### 💾 **influencers_schema.sql**
```sql
-- ============================================================
-- SEÇÃO 1: CRIAÇÃO DO SCHEMA (TABELAS E RELACIONAMENTOS)
-- ============================================================

CREATE TABLE TB_INFLUENCER (
    ID_INFLUENCER INT GENERATED ALWAYS AS IDENTITY,
    NM_INFLUENCER VARCHAR(120) NOT NULL,
    DS_EMAIL VARCHAR(120),
    DS_TELEFONE VARCHAR(15),
    DS_NICHO VARCHAR(100),
    DT_CADASTRO DATE NOT NULL DEFAULT CURRENT_DATE,
    QT_SEGUIDORES INT CHECK (QT_SEGUIDORES >= 0),
    VL_TAXA_BASE NUMERIC(12,2) CHECK (VL_TAXA_BASE >= 0),
    CONSTRAINT PK_TB_INFLUENCER PRIMARY KEY (ID_INFLUENCER)
);

CREATE TABLE TB_PLATAFORMA (
    ID_PLATAFORMA INT GENERATED ALWAYS AS IDENTITY,
    NM_PLATAFORMA VARCHAR(100) NOT NULL,
    CONSTRAINT PK_TB_PLATAFORMA PRIMARY KEY (ID_PLATAFORMA),
    CONSTRAINT UK_TB_PLATAFORMA_NM UNIQUE (NM_PLATAFORMA)
);

CREATE TABLE TB_MARCA (
    ID_MARCA INT GENERATED ALWAYS AS IDENTITY,
    NM_MARCA VARCHAR(120) NOT NULL,
    DS_EMAIL VARCHAR(120),
    DS_TELEFONE VARCHAR(15),
    DS_SEGMENTO VARCHAR(100),
    DT_CADASTRO DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT PK_TB_MARCA PRIMARY KEY (ID_MARCA)
);

CREATE TABLE TB_CONTRATO (
    ID_CONTRATO INT GENERATED ALWAYS AS IDENTITY,
    DS_NUMERO VARCHAR(15),
    FK_ID_MARCA INT NOT NULL,
    DT_INICIO DATE NOT NULL,
    DT_FIM DATE NOT NULL,
    VL_FECHADO NUMERIC(12,2) NOT NULL CHECK (VL_FECHADO >= 0),
    ST_STATUS VARCHAR(20) NOT NULL
        CHECK (ST_STATUS IN ('NEGOCIACAO','ATIVO','SUSPENSO','ENCERRADO')),
    DT_PAGAMENTO DATE,
    VL_PAGAMENTO NUMERIC(12,2) CHECK (VL_PAGAMENTO >= 0),
    DS_FORMA_PAGAMENTO VARCHAR(30),
    CONSTRAINT PK_TB_CONTRATO PRIMARY KEY (ID_CONTRATO),
    CONSTRAINT FK_TB_CONTRATO_MARCA FOREIGN KEY (FK_ID_MARCA)
        REFERENCES TB_MARCA(ID_MARCA) ON DELETE RESTRICT,
    CONSTRAINT CK_TB_CONTRATO_DT CHECK (DT_FIM >= DT_INICIO)
);

CREATE TABLE RL_INFLUENCER_PLATAFORMA (
    ID_INFLUENCER INT NOT NULL,
    ID_PLATAFORMA INT NOT NULL,
    DT_REFERENCIA DATE NOT NULL,
    DS_HANDLE VARCHAR(120) NOT NULL,
    QT_SEGUIDORES_ATUAL INT CHECK (QT_SEGUIDORES_ATUAL >= 0),
    DT_ATUALIZACAO DATE,
    QT_VIEWS INT CHECK (QT_VIEWS >= 0),
    QT_CLIQUES INT CHECK (QT_CLIQUES >= 0),
    QT_LIKES INT CHECK (QT_LIKES >= 0),
    QT_REACOES INT CHECK (QT_REACOES >= 0),
    QT_COMMENTS INT CHECK (QT_COMMENTS >= 0),
    QT_SHARES INT CHECK (QT_SHARES >= 0),
    VL_CUSTO NUMERIC(12,2) CHECK (VL_CUSTO >= 0),
    CONSTRAINT PK_RL_INFLUENCER_PLATAFORMA
        PRIMARY KEY (ID_INFLUENCER, ID_PLATAFORMA, DT_REFERENCIA),
    CONSTRAINT FK_RL_INF_PLAT_INFLU FOREIGN KEY (ID_INFLUENCER)
        REFERENCES TB_INFLUENCER(ID_INFLUENCER) ON DELETE CASCADE,
    CONSTRAINT FK_RL_INF_PLAT_PLAT FOREIGN KEY (ID_PLATAFORMA)
        REFERENCES TB_PLATAFORMA(ID_PLATAFORMA) ON DELETE CASCADE,
    CONSTRAINT UK_RL_INF_PLAT_HANDLE UNIQUE (ID_PLATAFORMA, DS_HANDLE)
);

CREATE TABLE RL_INFLUENCER_CONTRATO (
    ID_INFLUENCER INT NOT NULL,
    ID_CONTRATO INT NOT NULL,
    DS_OBJETIVO VARCHAR(255),
    DT_INICIO DATE NOT NULL,
    DT_FIM DATE NOT NULL,
    VL_ORCAMENTO NUMERIC(12,2) NOT NULL CHECK (VL_ORCAMENTO >= 0),
    ST_STATUS VARCHAR(20) NOT NULL
        CHECK (ST_STATUS IN ('PLANEJADA','ATIVA','PAUSADA','ENCERRADA')),
    CONSTRAINT PK_RL_INFLUENCER_CONTRATO PRIMARY KEY (ID_INFLUENCER, ID_CONTRATO),
    CONSTRAINT FK_RL_INF_CONTRATO_INFLU FOREIGN KEY (ID_INFLUENCER)
        REFERENCES TB_INFLUENCER(ID_INFLUENCER) ON DELETE CASCADE,
    CONSTRAINT FK_RL_INF_CONTRATO_CONTR FOREIGN KEY (ID_CONTRATO)
        REFERENCES TB_CONTRATO(ID_CONTRATO) ON DELETE CASCADE,
    CONSTRAINT CK_RL_INF_CONTRATO_DT CHECK (DT_FIM >= DT_INICIO)
);

-- ============================================================
-- SEÇÃO 2: INDEXAÇÃO
-- ============================================================

CREATE INDEX idx_rl_inf_plat_plataforma_ref
ON RL_INFLUENCER_PLATAFORMA (ID_PLATAFORMA, ID_INFLUENCER, DT_REFERENCIA);

-- ============================================================
-- SEÇÃO 3: POPULAÇÃO DE DADOS
-- ============================================================

INSERT INTO TB_PLATAFORMA (NM_PLATAFORMA)
VALUES ('Instagram'),('TikTok'),('YouTube'),('Facebook'),('Twitter');

INSERT INTO TB_MARCA (NM_MARCA, DS_EMAIL, DS_TELEFONE, DS_SEGMENTO)
VALUES
('Lúmina', 'contato@lumina.com', '+5571988000001', 'Moda/Beleza'),
('VerdeVibe', 'contato@verdevibe.com', '+5571988000002', 'Alimentos/Saúde'),
('TechNova', 'contato@technova.com', '+5571988000003', 'Tecnologia/Gadgets'),
('FitPulse', 'contato@fitpulse.com', '+5571988000004', 'Fitness/Wellness'),
('InovaArts', 'contato@inovaarts.com', '+5571988000005', 'Cultura/Entretenimento');

WITH primeiros_nomes AS (
    SELECT unnest(ARRAY[
        'Lucas','Ana','João','Mariana','Carlos','Beatriz','Felipe','Camila','Rafael','Larissa',
        'Eduardo','Juliana','Gustavo','Patrícia','Thiago','Carla','Bruno','Fernanda','Rodrigo','Renata',
        'Marcos','Tatiana','Ricardo','Cláudia','André','Sônia','Leandro','Vanessa','Fábio','Roberta',
        'Daniel','Aline','Marcelo','Paula','Eduarda','Vinícius','Priscila','Fernando','Gabriela','Igor',
        'Luana','Murilo','Caroline','Pedro','Renan','Bianca','Matheus','Juliane','Cássio','Larissa'
    ]) AS primeiro_nome
),
sobrenomes AS (
    SELECT unnest(ARRAY[
        'Moreno','Silva','Pereira','Costa','Oliveira','Santos','Almeida','Souza','Gomes','Rocha',
        'Lima','Fernandes','Martins','Ribeiro','Nunes','Melo','Carvalho','Azevedo','Pinto','Castro',
        'Barbosa','Teixeira','Freitas','Moura','Cardoso','Mendes','Ramos','Cavalcanti','Vieira','Assis',
        'Moreira','Queiroz','Figueiredo','Correia','Campos','Andrade','Mendonça','Tavares','Rezende','Cunha',
        'Siqueira','Borges','Machado','Lopes','Duarte','Coelho','Batista','Fonseca','Ribeiro','Sá'
    ]) AS sobrenome
)
INSERT INTO TB_INFLUENCER (NM_INFLUENCER, DS_EMAIL, DS_TELEFONE, DS_NICHO, QT_SEGUIDORES, VL_TAXA_BASE)
SELECT
    primeiro_nome || ' ' || sobrenome,
    LOWER(primeiro_nome || sobrenome) || '@email.com',
    '+5571' || LPAD((row_number() OVER() % 100000000)::text, 8, '0'),
    CASE (row_number() OVER() % 5)
        WHEN 0 THEN 'Moda'
        WHEN 1 THEN 'Fitness'
        WHEN 2 THEN 'Games'
        WHEN 3 THEN 'Beleza'
        ELSE 'Tecnologia'
    END,
    (RANDOM() * 1000000)::INT,
    (RANDOM() * 1000)::NUMERIC(12,2)
FROM primeiros_nomes
CROSS JOIN sobrenomes
LIMIT 5000;

INSERT INTO RL_INFLUENCER_PLATAFORMA
(ID_INFLUENCER, ID_PLATAFORMA, DS_HANDLE, QT_SEGUIDORES_ATUAL, DT_ATUALIZACAO, DT_REFERENCIA,
 QT_VIEWS, QT_CLIQUES, QT_LIKES, QT_REACOES, QT_COMMENTS, QT_SHARES, VL_CUSTO)
SELECT
    i.ID_INFLUENCER,
    p.ID_PLATAFORMA,
    'handle_' || i.ID_INFLUENCER || '_' || p.ID_PLATAFORMA,
    (RANDOM() * 1000000)::INT,
    CURRENT_DATE - ((i.ID_INFLUENCER + p.ID_PLATAFORMA) % 10 * INTERVAL '1 day'),
    CURRENT_DATE - ((i.ID_INFLUENCER + p.ID_PLATAFORMA) % 30 * INTERVAL '1 day'),
    (RANDOM() * 100000)::INT,
    CASE WHEN p.NM_PLATAFORMA IN ('Instagram','Facebook','YouTube') THEN (RANDOM() * 10000)::INT ELSE 0 END,
    CASE WHEN p.NM_PLATAFORMA IN ('Instagram','TikTok','YouTube','Twitter') THEN (RANDOM() * 5000)::INT ELSE 0 END,
    CASE WHEN p.NM_PLATAFORMA = 'Facebook' THEN (RANDOM() * 2000)::INT ELSE 0 END,
    CASE WHEN p.NM_PLATAFORMA = 'Facebook' THEN (RANDOM() * 500)::INT ELSE 0 END,
    (RANDOM() * 300)::INT,
    (RANDOM() * 1000)::NUMERIC(12,2)
FROM TB_INFLUENCER i
JOIN TB_PLATAFORMA p ON (p.ID_PLATAFORMA <= ((i.ID_INFLUENCER % 5) + 1));

INSERT INTO TB_CONTRATO (DS_NUMERO, FK_ID_MARCA, DT_INICIO, DT_FIM, VL_FECHADO, ST_STATUS, DT_PAGAMENTO, VL_PAGAMENTO, DS_FORMA_PAGAMENTO)
SELECT
    'C' || LPAD((row_number() OVER())::text, 4, '0'),
    ((row_number() OVER() % 5) + 1),
    CURRENT_DATE - ((row_number() OVER() % 100) * INTERVAL '1 day'),
    CURRENT_DATE + ((row_number() OVER() % 100) * INTERVAL '1 day'),
    (RANDOM() * 50000)::NUMERIC(12,2),
    CASE (row_number() OVER() % 4)
        WHEN 0 THEN 'NEGOCIACAO'
        WHEN 1 THEN 'ATIVO'
        WHEN 2 THEN 'SUSPENSO'
        ELSE 'ENCERRADO'
    END,
    CURRENT_DATE - ((row_number() OVER() % 30) * INTERVAL '1 day'),
    (RANDOM() * 50000)::NUMERIC(12,2),
    CASE (row_number() OVER() % 3)
        WHEN 0 THEN 'PIX'
        WHEN 1 THEN 'Boleto'
        ELSE 'Transferência'
    END
FROM generate_series(1,1000);

INSERT INTO RL_INFLUENCER_CONTRATO (ID_INFLUENCER, ID_CONTRATO, DS_OBJETIVO, DT_INICIO, DT_FIM, VL_ORCAMENTO, ST_STATUS)
SELECT
    i.ID_INFLUENCER,
    c.ID_CONTRATO,
    'Campanha ' || c.ID_CONTRATO || ' para Influencer ' || i.ID_INFLUENCER,
    c.DT_INICIO,
    c.DT_FIM,
    (RANDOM() * 10000)::NUMERIC(12,2),
    CASE (i.ID_INFLUENCER % 4)
        WHEN 0 THEN 'PLANEJADA'
        WHEN 1 THEN 'ATIVA'
        WHEN 2 THEN 'PAUSADA'
        ELSE 'ENCERRADA'
    END
FROM TB_INFLUENCER i
JOIN TB_CONTRATO c ON (c.ID_CONTRATO % 5 = i.ID_INFLUENCER % 5)
WHERE i.ID_INFLUENCER <= 5000;
