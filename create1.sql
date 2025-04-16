DROP TABLE IF EXISTS PessoaFuncionario;
DROP TABLE IF EXISTS CargoSalario;
DROP TABLE IF EXISTS PessoaCliente;
DROP TABLE IF EXISTS Fornecedor;
DROP TABLE IF EXISTS Fornece;
DROP TABLE IF EXISTS Categoria;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Compra;
DROP TABLE IF EXISTS ItemCompra;
DROP TABLE IF EXISTS Venda;
DROP TABLE IF EXISTS MetodoPagamento;
DROP TABLE IF EXISTS ItemVenda;

PRAGMA foreign_keys = ON;

CREATE TABLE CargoSalario(
    CARGO TEXT,
    SALARIO REAL CHECK(SALARIO > 0),
    PRIMARY KEY (CARGO)
);

CREATE TABLE PessoaFuncionario(
    NIF INTEGER CHECK (LENGTH(CAST(NIF AS TEXT)) = 9),
    NAME TEXT NOT NULL,
    DATANASCIMENTO DATE NOT NULL,
    CARGO TEXT NOT NULL,
    PRIMARY KEY (NIF),
    FOREIGN KEY (CARGO) REFERENCES CargoSalario(CARGO) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE PessoaCliente(
    NIF TEXT CHECK (LENGTH(CAST(NIF AS TEXT)) = 9),
    NAME TEXT NOT NULL,
    DATANASCIMENTO DATE NOT NULL,
    MORADA TEXT NOT NULL,

    PRIMARY KEY (NIF)
);

CREATE TABLE Fornecedor(
    NIPC INTEGER CHECK (LENGTH(CAST(NIPC AS TEXT)) = 9),
    NOME TEXT NOT NULL,
    MORADA TEXT NOT NULL,
    EMAIL TEXT NOT NULL,
    TELEFONE INTEGER CHECK(LENGTH(CAST(TELEFONE AS TEXT)) = 9),

    PRIMARY KEY (NIPC)
);

CREATE TABLE Produto(
    CODIGO INTEGER CHECK(LENGTH(CAST(CODIGO AS TEXT)) = 13),
    DESCRICAO TEXT NOT NULL,
    CUSTO REAL NOT NULL,
    CATEGORIA TEXT NOT NULL,
    QUANTIDADE INTEGER DEFAULT 0 CHECK(QUANTIDADE >=0),
    FORNECEDOR INTEGER NOT NULL,

    PRIMARY KEY (CODIGO),
    FOREIGN KEY (CATEGORIA) REFERENCES Categoria(TIPO) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (FORNECEDOR) REFERENCES Fornecedor(NIPC) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Fornece(
    NIPC INTEGER CHECK(LENGTH(CAST(NIPC AS TEXT)) = 9),
    CODIGO INTEGER,
    PRAZOENTREGA DATE NOT NULL,

    PRIMARY KEY (NIPC, CODIGO),
    FOREIGN KEY (NIPC) REFERENCES Fornecedor(NIPC) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (CODIGO) REFERENCES Produto(CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Categoria(
    TIPO TEXT,
    RESTRITO BOOLEAN NOT NULL,

    PRIMARY KEY (TIPO)
);

CREATE TABLE Compra(
    IDCOMPRA INTEGER CHECK(LENGTH(CAST(IDCOMPRA AS TEXT)) = 9),
    DATACOMPRA DATE NOT NULL,
    QUANTIDADECOMRPA INTEGER DEFAULT 1,
    VALORTOTAL REAL CHECK(VALORTOTAL > 0),
    FORNECEDOR TEXT NOT NULL,

    PRIMARY KEY (IDCOMPRA),
    FOREIGN KEY (FORNECEDOR) REFERENCES Fornecedor(NIPC) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE ItemCompra(
    CODIGOITEM INTEGER,
    IDCOMPRA INTEGER,
    PRECOUNIDADE REAL NOT NULL,
    QUANTIDADE INTEGER NOT NULL,

    PRIMARY KEY (CODIGOITEM, IDCOMPRA),
    FOREIGN KEY (CODIGOITEM) REFERENCES Produto(CODIGO) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (IDCOMPRA) REFERENCES Compra(IDCOMPRA) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE MetodoPagamento(
    TIPO TEXT,
    STATUS TEXT NOT NULL,
    PRIMARY KEY (TIPO)
);

CREATE TABLE Venda(
    IDVENDA INTEGER CHECK(LENGTH(CAST(IDVENDA AS TEXT)) = 9),
    IDCLIENTE INTEGER,
    IDVENDEDOR INTEGER,
    DATAVENDA DATE NOT NULL,
    VALORTOTAL REAL CHECK(VALORTOTAL > 0),
    METODOPAGAMENTO TEXT NOT NULL,
    
    PRIMARY KEY (IDVENDA),
    FOREIGN KEY (IDCLIENTE) REFERENCES PessoaCliente(NIF) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (IDVENDEDOR) REFERENCES PessoaFuncionario(NIF) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (METODOPAGAMENTO) REFERENCES MetodoPagamento(TIPO) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE ItemVenda(
    CODIGOITEM INTEGER,
    IDVENDA INTEGER,
    PRECOUNIDADE REAL CHECK(PRECOUNIDADE > 0),
    QUANTIDADE INTEGER DEFAULT 1 CHECK(QUANTIDADE > 0),

    PRIMARY KEY (CODIGOITEM , IDVENDA),
    FOREIGN KEY (CODIGOITEM ) REFERENCES Produto(CODIGO) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (IDVENDA) REFERENCES Venda(IDVENDA) ON UPDATE CASCADE ON DELETE SET NULL
);