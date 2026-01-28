# Projeto Lógico de Banco de Dados - E-commerce

Este projeto consiste na modelagem e implementação lógica de um banco de dados para um cenário de E-commerce, atendendo a requisitos de negócio complexos como distinção de clientes PF/PJ, múltiplas formas de pagamento e rastreio de entregas.

## 🛠️ Tecnologias Utilizadas
- **Banco de Dados:** MySQL
- **Ferramenta de Modelagem:** MySQL Workbench

## 📋 Desafios Resolvidos
O esquema original foi refinado para suportar:
1.  **Cliente PJ e PF:** Implementada estratégia de herança/especialização (tabelas `Individual_Person` e `Legal_Entity`) para garantir integridade de dados fiscais (CPF/CNPJ).
2.  **Pagamentos Múltiplos:** Um cliente pode cadastrar diversas formas de pagamento (cartão, boleto, pix), resolvido com uma relação 1:N.
3.  **Entrega:** Controle de status e código de rastreio vinculado ao pedido.

## 📂 Estrutura do Projeto
- `/src/01_schema.sql`: Script DDL para criação do banco e tabelas.
- `/src/02_data.sql`: Script DML para população de dados de teste.
- `/src/03_queries.sql`: Consultas SQL complexas (JOINs, HAVING, Agregações).

## 🚀 Como Rodar
1. Clone o repositório.
2. Importe o script `01_schema.sql` no seu servidor MySQL.
3. Execute o script `02_data.sql` para carregar os dados.
4. Utilize o script `03_queries.sql` para validar as regras de negócio.

## 📊 Perguntas de Negócio Respondidas
As queries elaboradas respondem a questões como:
- Quantos pedidos foram feitos por cada cliente?
- Qual a relação de fornecedores e produtos?
- Quais produtos têm baixo estoque?
