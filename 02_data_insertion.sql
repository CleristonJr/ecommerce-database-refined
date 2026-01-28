USE ecommerce_refined;

-- 1. Inserindo Clientes (A base para PF e PJ)
-- Vamos criar 4 clientes: 2 PF e 2 PJ
INSERT INTO Clients (idClient, Fname, Minit, Lname, Address, Phone) VALUES
(1, 'Maria', 'M', 'Silva', 'Rua Silva de Prata 29, Carangola - Cidade das Flores', '(11) 91234-5678'),
(2, 'Matheus', 'O', 'Pimentel', 'Rua Alemeda 289, Centro - Cidade das Flores', '(11) 99876-5432'),
(3, 'Ricardo', 'F', 'Silva', 'Av. Koller 19, Centro - Cidade das Flores', '(21) 99999-1111'),
(4, 'Julia', 'S', 'França', 'Rua Lareijras 861, Centro - Cidade das Flores', '(21) 98888-2222');

-- 2. Inserindo Pessoa Física (Vinculado a Clients 1 e 2)
INSERT INTO Individual_Person (idClient, CPF, RG, BirthDate) VALUES
(1, '12345678900', '123456789', '1990-01-15'),
(2, '98765432100', '987654321', '1995-07-20');

-- 3. Inserindo Pessoa Jurídica (Vinculado a Clients 3 e 4)
INSERT INTO Legal_Entity (idClient, CNPJ, TradeName, CorporateName) VALUES
(3, '12345678000199', 'Ricardo Eletro', 'Ricardo Eletro LTDA'),
(4, '98765432000188', 'França Variedades', 'J. França Comércio LTDA');

-- 4. Inserindo Produtos (Categorias variadas)
INSERT INTO Product (Pname, Classification_Kids, Category, Evaluation, Size, Price) VALUES
('Fone de Ouvido', FALSE, 'Eletrônico', 4, NULL, 50.00),
('Barbie Elsa', TRUE, 'Brinquedos', 3, NULL, 120.00),
('Body Carters', TRUE, 'Vestuário', 5, 'M', 70.00),
('Microfone Vedo', FALSE, 'Eletrônico', 4, NULL, 150.00),
('Sofá Retrátil', FALSE, 'Móveis', 3, '3x57x80', 1200.00);

-- 5. Inserindo Armazéns (Estoque)
INSERT INTO Warehouse (Location, Manager) VALUES
('Rio de Janeiro', 'Bento'),
('São Paulo', 'Fernanda'),
('Brasília', 'José');

-- 6. Inserindo Estoque dos Produtos
INSERT INTO ProductStorage (idProduct, idWarehouse, Quantity) VALUES
(1, 2, 1000),
(2, 2, 500),
(3, 1, 60),
(4, 3, 100),
(5, 1, 10);

-- 7. Inserindo Fornecedores
INSERT INTO Supplier (SocialName, CNPJ, Contact) VALUES
('Almeida e Filhos', '12345678912345', '21985474'),
('Eletrônicos Silva', '85451964914345', '21985484'),
('Eletrônicos Valma', '93456789393469', '21975474');

-- 8. Vinculando Produto ao Fornecedor
INSERT INTO ProductSupplier (idSupplier, idProduct, Quantity) VALUES
(1, 1, 500),
(1, 2, 400),
(2, 4, 633),
(3, 3, 5),
(2, 5, 10);

-- 9. Inserindo Pedidos (Alguns clientes terão mais de um pedido)
INSERT INTO Orders (idClient, OrderStatus, OrderDescription, Freight, TotalAmount) VALUES
(1, 'Em processamento', 'Compra via App', 10.00, 60.00),
(2, 'Em processamento', 'Compra via Web', 25.00, 1225.00),
(3, 'Confirmado', NULL, 0.00, 150.00),
(4, 'Em processamento', 'Compra Web', 15.00, 210.00),
(1, 'Confirmado', 'Compra recorrente', 10.00, 120.00); -- Cliente 1 repetido

-- 10. Inserindo Itens do Pedido (N:M)
INSERT INTO ProductOrder (idOrder, idProduct, PoQuantity, PoStatus) VALUES
(1, 1, 1, 'Disponível'),
(2, 5, 1, 'Disponível'), -- Sofá
(3, 4, 1, 'Disponível'),
(4, 3, 3, 'Disponível'),
(5, 2, 1, 'Disponível');

-- 11. Inserindo Entregas (Apenas para pedidos confirmados ou enviados)
INSERT INTO Delivery (idOrder, TrackingCode, DeliveryStatus, ExpectedDate) VALUES
(1, 'BR123456', 'Em separação', '2023-12-01'),
(3, 'BR987654', 'Enviado', '2023-11-25'),
(5, 'BR555666', 'Entregue', '2023-11-20');

-- 12. Inserindo Pagamentos (Um cliente com múltiplas formas)
INSERT INTO Payments (idClient, PaymentType, CardNumber, CardHolderName, ExpirationDate) VALUES
(1, 'Credit_Card', '1234 **** **** 3456', 'MARIA SILVA', '2028-01-01'),
(1, 'Pix', NULL, NULL, NULL), -- Maria tem 2 formas
(2, 'Boleto', NULL, NULL, NULL),
(4, 'Debit_Card', '4321 **** **** 9876', 'JULIA FRANCA', '2026-05-01');