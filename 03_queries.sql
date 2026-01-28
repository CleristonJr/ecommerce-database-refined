USE ecommerce_refined;

-- ---------------------------------------------------------
-- QUERY 1: Recuperações simples com SELECT Statement
-- Pergunta: Listar nome e sobrenome de todos os clientes Pessoa Física.
-- ---------------------------------------------------------
SELECT c.Fname, c.Lname, pf.CPF
FROM Clients c
INNER JOIN Individual_Person pf ON c.idClient = pf.idClient;


-- ---------------------------------------------------------
-- QUERY 2: Filtros com WHERE Statement
-- Pergunta: Quais pedidos estão atualmente "Em processamento"?
-- ---------------------------------------------------------
SELECT idOrder, OrderDescription, CreatedAt 
FROM Orders 
WHERE OrderStatus = 'Em processamento';


-- ---------------------------------------------------------
-- QUERY 3: Crie expressões para gerar atributos derivados
-- Pergunta: Qual o valor total de cada item do pedido (Qtd * Preço Unitário)?
-- Contexto: Precisamos pegar o preço da tabela Produto e multiplicar pela qtd da tabela ProductOrder.
-- ---------------------------------------------------------
SELECT 
    po.idOrder,
    p.Pname AS Produto,
    po.PoQuantity AS Quantidade,
    p.Price AS Valor_Unitario,
    (po.PoQuantity * p.Price) AS Valor_Total_Item
FROM ProductOrder po
INNER JOIN Product p ON po.idProduct = p.idProduct;


-- ---------------------------------------------------------
-- QUERY 4: Defina ordenações dos dados com ORDER BY
-- Pergunta: Listar todos os produtos ordenados pelo preço (do mais caro para o mais barato).
-- ---------------------------------------------------------
SELECT Pname, Category, Price 
FROM Product 
ORDER BY Price DESC;


-- ---------------------------------------------------------
-- QUERY 5: Condições de filtros aos grupos – HAVING Statement
-- Pergunta: Quais clientes fizeram mais de 1 pedido no total?
-- ---------------------------------------------------------
SELECT 
    c.Fname, 
    COUNT(o.idOrder) AS Total_Pedidos
FROM Clients c
INNER JOIN Orders o ON c.idClient = o.idClient
GROUP BY c.idClient
HAVING Total_Pedidos > 1;


-- ---------------------------------------------------------
-- QUERY 6: Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
-- Pergunta: Relação completa de Pedidos: Quem comprou, o que comprou, qual o status da entrega e o rastreio?
-- Nota: Usa LEFT JOIN para trazer pedidos mesmo que ainda não tenham entrega gerada.
-- ---------------------------------------------------------
SELECT 
    o.idOrder AS Pedido,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    o.OrderStatus AS Status_Pedido,
    d.DeliveryStatus AS Status_Entrega,
    d.TrackingCode AS Codigo_Rastreio
FROM Orders o
INNER JOIN Clients c ON o.idClient = c.idClient
LEFT JOIN Delivery d ON o.idOrder = d.idOrder;


-- ---------------------------------------------------------
-- QUERY EXTRA (Desafio): Relação de Relação de nomes dos fornecedores e nomes dos produtos
-- Pergunta: Quais produtos são fornecidos por qual fornecedor e quanto tem em estoque no fornecedor?
-- ---------------------------------------------------------
SELECT 
    f.SocialName AS Fornecedor,
    p.Pname AS Produto,
    p.Category AS Categoria,
    ps.Quantity AS Estoque_No_Fornecedor
FROM Supplier f
INNER JOIN ProductSupplier ps ON f.idSupplier = ps.idSupplier
INNER JOIN Product p ON ps.idProduct = p.idProduct
ORDER BY f.SocialName;