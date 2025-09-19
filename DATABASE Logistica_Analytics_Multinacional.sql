/**********************************************************************
* BANCO DE DADOS: LOGISTICA_ANALYTICS_MULTINACIONAL
* CRIADO POR: Cristiano de Godoi
* CURSO: Data Analytics 12 - Yto Nihon Treinamentos
* DATA: 10/08/2025
*
* Script completo: staging, dimensões, fato, população, views, selects.
* Operação multinacional com dados Brasil, EUA, Alemanha, Japão.
**********************************************************************/

--CREATE DATABASE Logistica_Analytics_Multinacional;
--USE Logistica_Analytics_Multinacional;

-- 2. Criar tabela staging - dados brutos
CREATE TABLE staging_EntregaItens (
    NumPedido           INT PRIMARY KEY,
    NomeCliente         VARCHAR(120),
    EmailCliente        VARCHAR(200),
    Telefone            VARCHAR(30),
    Cidade              VARCHAR(80),
    Estado              VARCHAR(50),
    Pais                VARCHAR(50),
    CentroDistribuicao  VARCHAR(100),
    Produto             VARCHAR(120),
    Categoria           VARCHAR(60),
    QtdeUnidades        INT,
    PrecoUnitario       DECIMAL(10,2),
    CustoFrete          DECIMAL(10,2),
    DataEnvio           DATE,
    DataEntrega         DATE,
    StatusEntrega       VARCHAR(30),
    Transportadora      VARCHAR(120),
    PlacaVeiculo        VARCHAR(20),
    Motorista           VARCHAR(120)
);

-- 3. Criar tabelas Dimensão

CREATE TABLE DimData (
    DataID          INT IDENTITY(1,1) PRIMARY KEY,
    Data            DATE UNIQUE,
    Ano             INT,
    Mes             INT,
    Dia             INT,
    DiaSemana       VARCHAR(20),
    Trimestre       INT
);

CREATE TABLE DimCliente (
    ClienteID       INT IDENTITY(1,1) PRIMARY KEY,
    NomeCliente     VARCHAR(120),
    EmailCliente    VARCHAR(200) UNIQUE,
    Telefone        VARCHAR(30),
    Pais            VARCHAR(50)
);

CREATE TABLE DimProduto (
    ProdutoID       INT IDENTITY(1,1) PRIMARY KEY,
    NomeProduto     VARCHAR(120),
    Categoria       VARCHAR(60),
    PrecoUnitario   DECIMAL(10,2)
);

CREATE TABLE DimLocalidade (
    LocalidadeID        INT IDENTITY(1,1) PRIMARY KEY,
    Cidade              VARCHAR(80),
    Estado              VARCHAR(50),
    Pais                VARCHAR(50),
    CentroDistribuicao  VARCHAR(100),
    TipoLocalidade      VARCHAR(30), -- 'CD' ou 'Aeroporto'
    CONSTRAINT UQ_Localidade UNIQUE (Cidade, Estado, Pais, CentroDistribuicao)
);

-- 4. Criar tabela fato

CREATE TABLE FatoEntregas (
    FatoID          INT IDENTITY(1,1) PRIMARY KEY,
    NumPedido       INT UNIQUE,
    DataEnvioID     INT,
    DataEntregaID   INT,
    ClienteID       INT,
    ProdutoID       INT,
    LocalidadeID    INT,
    QtdeUnidades    INT,
    PrecoUnitario   DECIMAL(10,2),
    CustoFrete      DECIMAL(10,2),
    ValorTotal      DECIMAL(12,2),
    LeadTimeDias    INT,
    StatusEntrega   VARCHAR(30),
    Transportadora  VARCHAR(120),
    PlacaVeiculo    VARCHAR(20),
    Motorista       VARCHAR(120),

    CONSTRAINT FK_Fato_DataEnvio FOREIGN KEY (DataEnvioID) REFERENCES DimData(DataID),
    CONSTRAINT FK_Fato_DataEntrega FOREIGN KEY (DataEntregaID) REFERENCES DimData(DataID),
    CONSTRAINT FK_Fato_Cliente FOREIGN KEY (ClienteID) REFERENCES DimCliente(ClienteID),
    CONSTRAINT FK_Fato_Produto FOREIGN KEY (ProdutoID) REFERENCES DimProduto(ProdutoID),
    CONSTRAINT FK_Fato_Localidade FOREIGN KEY (LocalidadeID) REFERENCES DimLocalidade(LocalidadeID)
);

--5. População da tabela staging com dados multinacionais

INSERT INTO staging_EntregaItens
(NumPedido, NomeCliente, EmailCliente, Telefone, Cidade, Estado, Pais, CentroDistribuicao, Produto, Categoria, QtdeUnidades, PrecoUnitario, CustoFrete, DataEnvio, DataEntrega, StatusEntrega, Transportadora, PlacaVeiculo, Motorista)
VALUES
(6001,'João Silva','joao.brasil@exemplo.com','+5511988880001','São Paulo','SP','Brasil','CD São Paulo','Notebook Dell Inspiron','Notebook',1,3500.00,120.00,'2025-01-05','2025-01-06','Entregue','Translog','ABC1A23','Carlos Souza'),
(6002,'Maria Souza','maria.brasil@exemplo.com','+5511988880002','Campinas','SP','Brasil','CD Campinas','Smartphone Samsung S23','Smartphone',2,4200.00,90.00,'2025-01-05','2025-01-07','Entregue','Rapidão Express','BCD2B34','Ana Ramos'),
(6003,'John Doe','john.usa@example.com','+13105550001','Miami','FL','USA','CD Miami','Apple MacBook Pro','Notebook',1,2500.00,150.00,'2025-01-06','2025-01-07','Entregue','FastShip','USA123','Mike Johnson'),
(6004,'Jane Smith','jane.usa@example.com','+14165550002','San Francisco','CA','USA','CD San Francisco','Amazon Echo Dot','Smart Home',3,120.00,30.00,'2025-01-06','2025-01-08','Entregue','Express USA','USA234','Linda White'),
(6005,'Hans Müller','hans.de@beispiel.de','+4915123456789','Frankfurt','Hesse','Germany','CD Frankfurt','Samsung Galaxy S23','Smartphone',1,900.00,100.00,'2025-01-07','2025-01-08','Entregue','Schnell Liefer','GER123','Fritz Weber'),
(6006,'Anna Schmidt','anna.de@beispiel.de','+4915987654321','Berlin','Berlin','Germany','CD Berlin','Sony WH-1000XM5','Áudio',2,300.00,50.00,'2025-01-07','2025-01-09','Entregue','Schnell Liefer','GER234','Helga Fischer'),
(6007,'Takeshi Tanaka','takeshi.jp@example.jp','+819012345678','Tóquio','Tokyo','Japan','CD Tokyo','Nintendo Switch','Console',1,350.00,70.00,'2025-01-08','2025-01-10','Entregue','Nihon Express','JPN123','Ken Watanabe'),
(6008,'Yuki Sato','yuki.jp@example.jp','+819087654321','Osaka','Osaka','Japan','CD Osaka','Sony PlayStation 5','Console',1,500.00,60.00,'2025-01-08','2025-01-11','Entregue','Nihon Express','JPN234','Haruki Yamada');

-- 6. Popular DimData (datas únicas de envio e entrega)

INSERT INTO DimData (Data, Ano, Mes, Dia, DiaSemana, Trimestre)
SELECT DISTINCT
    Data,
    YEAR(Data),
    MONTH(Data),
    DAY(Data),
    DATENAME(weekday, Data),
    DATEPART(quarter, Data)
FROM (
    SELECT DataEnvio AS Data FROM staging_EntregaItens
    UNION
    SELECT DataEntrega FROM staging_EntregaItens
) AS Datas
WHERE Data NOT IN (SELECT Data FROM DimData);

-- 7. Popular DimCliente (clientes únicos)

INSERT INTO DimCliente (NomeCliente, EmailCliente, Telefone, Pais)
SELECT DISTINCT
    NomeCliente,
    EmailCliente,
    Telefone,
    Pais
FROM staging_EntregaItens s
WHERE NOT EXISTS (
    SELECT 1 FROM DimCliente c WHERE c.EmailCliente = s.EmailCliente
);

-- 8. Popular DimProduto (produtos únicos)

INSERT INTO DimProduto (NomeProduto, Categoria, PrecoUnitario)
SELECT DISTINCT
    Produto,
    Categoria,
    PrecoUnitario
FROM staging_EntregaItens s
WHERE NOT EXISTS (
    SELECT 1 FROM DimProduto p WHERE p.NomeProduto = s.Produto
);

-- 9. Popular DimLocalidade (CDs)

INSERT INTO DimLocalidade (Cidade, Estado, Pais, CentroDistribuicao, TipoLocalidade)
SELECT DISTINCT
    Cidade,
    Estado,
    Pais,
    CentroDistribuicao,
    'CD'
FROM staging_EntregaItens s
WHERE NOT EXISTS (
    SELECT 1 FROM DimLocalidade l
    WHERE l.Cidade = s.Cidade
      AND l.Estado = s.Estado
      AND l.Pais = s.Pais
      AND l.CentroDistribuicao = s.CentroDistribuicao
);

-- 10. Inserir aeroportos multinacionais

INSERT INTO DimLocalidade (Cidade, Estado, Pais, CentroDistribuicao, TipoLocalidade)
VALUES
('Miami', 'FL', 'USA', 'Aeroporto Internacional de Miami (MIA)', 'Aeroporto'),
('Frankfurt', 'Hesse', 'Germany', 'Aeroporto de Frankfurt (FRA)', 'Aeroporto'),
('Tóquio', 'Tokyo', 'Japan', 'Aeroporto de Narita (NRT)', 'Aeroporto'),
('São Paulo', 'SP', 'Brasil', 'Aeroporto Internacional de Guarulhos (GRU)', 'Aeroporto'),
('Berlim', 'Berlin', 'Germany', 'Aeroporto de Berlim Brandenburg (BER)', 'Aeroporto'),
('Osaka', 'Osaka', 'Japan', 'Aeroporto Internacional de Kansai (KIX)', 'Aeroporto');

-- 11. Popular tabela fato FatoEntregas

INSERT INTO FatoEntregas
(NumPedido, DataEnvioID, DataEntregaID, ClienteID, ProdutoID, LocalidadeID, QtdeUnidades, PrecoUnitario, CustoFrete, ValorTotal, LeadTimeDias, StatusEntrega, Transportadora, PlacaVeiculo, Motorista)
SELECT 
    s.NumPedido,
    dEnv.DataID,
    dEnt.DataID,
    c.ClienteID,
    p.ProdutoID,
    l.LocalidadeID,
    s.QtdeUnidades,
    s.PrecoUnitario,
    s.CustoFrete,
    (s.PrecoUnitario * s.QtdeUnidades) + s.CustoFrete AS ValorTotal,
    DATEDIFF(day, s.DataEnvio, s.DataEntrega) AS LeadTimeDias,
    s.StatusEntrega,
    s.Transportadora,
    s.PlacaVeiculo,
    s.Motorista
FROM staging_EntregaItens s
JOIN DimData dEnv ON s.DataEnvio = dEnv.Data
JOIN DimData dEnt ON s.DataEntrega = dEnt.Data
JOIN DimCliente c ON s.EmailCliente = c.EmailCliente
JOIN DimProduto p ON s.Produto = p.NomeProduto
JOIN DimLocalidade l ON s.Cidade = l.Cidade AND s.Estado = l.Estado AND s.Pais = l.Pais AND s.CentroDistribuicao = l.CentroDistribuicao;

-- 12. Views para facilitar consultas

-- Resumo das entregas
IF OBJECT_ID('vw_ResumoEntregas', 'V') IS NOT NULL
    DROP VIEW vw_ResumoEntregas;

CREATE VIEW vw_ResumoEntregas AS
SELECT
    f.NumPedido,
    c.NomeCliente,
    c.Pais AS PaisCliente,
    p.NomeProduto,
    p.Categoria,
    l.Cidade,
    l.Pais AS PaisCD,
    f.QtdeUnidades,
    f.PrecoUnitario,
    f.CustoFrete,
    f.ValorTotal,
    f.LeadTimeDias,
    f.StatusEntrega,
    f.Transportadora,
    f.Motorista,
    dEnv.Data AS DataEnvio,
    dEnt.Data AS DataEntrega
FROM FatoEntregas f
JOIN DimCliente c ON f.ClienteID = c.ClienteID
JOIN DimProduto p ON f.ProdutoID = p.ProdutoID
JOIN DimLocalidade l ON f.LocalidadeID = l.LocalidadeID
JOIN DimData dEnv ON f.DataEnvioID = dEnv.DataID
JOIN DimData dEnt ON f.DataEntregaID = dEnt.DataID;

-- Valor total e tempo médio por país e status
IF OBJECT_ID('vw_ValorPorPaisStatus', 'V') IS NOT NULL
    DROP VIEW vw_ValorPorPaisStatus;

    CREATE VIEW vw_ValorPorPaisStatus AS
SELECT
    c.Pais,
    f.StatusEntrega,
    COUNT(f.NumPedido) AS TotalPedidos,
    SUM(f.ValorTotal) AS ReceitaTotal,
    AVG(f.LeadTimeDias) AS TempoMedioEntrega
FROM FatoEntregas f
JOIN DimCliente c ON f.ClienteID = c.ClienteID
GROUP BY c.Pais, f.StatusEntrega;


-- 13. Realize a consulta dos dadoa abaixo.

SELECT TOP 10 * FROM staging_EntregaItens;

-- Dimensões
SELECT TOP 10 * FROM DimCliente;
SELECT TOP 10 * FROM DimProduto;
SELECT TOP 15 * FROM DimLocalidade;
SELECT TOP 10 * FROM DimData;

-- Fato
SELECT TOP 10 * FROM FatoEntregas;

-- Views
SELECT TOP 10 * FROM vw_ResumoEntregas;
SELECT * FROM vw_ValorPorPaisStatus;
GO

-- Fim--
