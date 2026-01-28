-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS ecommerce_refined;
USE ecommerce_refined;

-- 1. TABELA PAI: CLIENTE
-- Armazena os dados comuns a todos os tipos de cliente.
CREATE TABLE Clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15),
    Minit CHAR(3),
    Lname VARCHAR(20),
    Address VARCHAR(255),
    Phone VARCHAR(20),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. REFINAMENTO: PESSOA FÍSICA (1:1 com Clients)
-- A chave primária aqui é TAMBÉM a chave estrangeira.
CREATE TABLE Individual_Person (
    idClient INT NOT NULL,
    CPF CHAR(11) NOT NULL,
    RG VARCHAR(15),
    BirthDate DATE,
    PRIMARY KEY (idClient),
    UNIQUE (CPF),
    CONSTRAINT fk_individual_client FOREIGN KEY (idClient) 
        REFERENCES Clients(idClient) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. REFINAMENTO: PESSOA JURÍDICA (1:1 com Clients)
-- Garante a separação dos dados fiscais.
CREATE TABLE Legal_Entity (
    idClient INT NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    TradeName VARCHAR(100) NOT NULL COMMENT 'Nome Fantasia',
    CorporateName VARCHAR(100) NOT NULL COMMENT 'Razão Social',
    PRIMARY KEY (idClient),
    UNIQUE (CNPJ),
    CONSTRAINT fk_legal_client FOREIGN KEY (idClient) 
        REFERENCES Clients(idClient) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. REFINAMENTO: PAGAMENTOS (1:N com Clients)
-- Um cliente pode ter múltiplas formas de pagamento.
CREATE TABLE Payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    PaymentType ENUM('Credit_Card', 'Debit_Card', 'Boleto', 'Pix') NOT NULL,
    CardNumber VARCHAR(20) COMMENT 'Armazenar apenas token ou últimos 4 dígitos em prod',
    CardHolderName VARCHAR(100),
    ExpirationDate DATE,
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) 
        REFERENCES Clients(idClient) ON DELETE CASCADE
);

-- 5. PRODUTOS E ESTOQUE
CREATE TABLE Product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    Classification_Kids BOOL DEFAULT FALSE,
    Category ENUM('Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    Evaluation FLOAT DEFAULT 0,
    Size VARCHAR(10),
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Warehouse (
    idWarehouse INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(255) NOT NULL,
    Manager VARCHAR(50)
);

CREATE TABLE ProductStorage (
    idProduct INT NOT NULL,
    idWarehouse INT NOT NULL,
    Quantity INT DEFAULT 0,
    PRIMARY KEY (idProduct, idWarehouse),
    CONSTRAINT fk_storage_product FOREIGN KEY (idProduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_storage_warehouse FOREIGN KEY (idWarehouse) REFERENCES Warehouse(idWarehouse)
);

-- 6. FORNECEDORES
CREATE TABLE Supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE,
    Contact CHAR(11) NOT NULL
);

CREATE TABLE ProductSupplier (
    idSupplier INT NOT NULL,
    idProduct INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (idSupplier, idProduct),
    CONSTRAINT fk_prod_supplier_supplier FOREIGN KEY (idSupplier) REFERENCES Supplier(idSupplier),
    CONSTRAINT fk_prod_supplier_product FOREIGN KEY (idProduct) REFERENCES Product(idProduct)
);

-- 7. PEDIDOS (Orders)
CREATE TABLE Orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    OrderDescription VARCHAR(255),
    Freight DECIMAL(10,2) DEFAULT 0.00,
    TotalAmount DECIMAL(10,2), -- Pode ser calculado via query, mas bom persistir histórico
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_client FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- 8. REFINAMENTO: ENTREGA (1:1 com Orders)
-- Separa a logística da venda.
CREATE TABLE Delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    TrackingCode VARCHAR(50),
    DeliveryStatus ENUM('Em separação', 'Enviado', 'Em trânsito', 'Entregue', 'Devolvido') DEFAULT 'Em separação',
    ExpectedDate DATE,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES Orders(idOrder)
);

-- 9. ITENS DO PEDIDO (N:M Produto x Pedido)
CREATE TABLE ProductOrder (
    idProduct INT NOT NULL,
    idOrder INT NOT NULL,
    PoQuantity INT DEFAULT 1,
    PoStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idProduct, idOrder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idProduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idOrder) REFERENCES Orders(idOrder)
);