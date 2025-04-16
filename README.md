# Sistema de gerenciamento de supermercado  
**Banco de dados**
---

## 1. Descrição do Contexto

O ponto central do projeto é o desenvolvimento de um sistema para gerir o estoque de um supermercado. Ele permitirá otimizar o controle e monitorar os diferentes produtos do estoque. O foco do sistema é gerenciar vários aspectos do fluxo de produtos, desde a compra dos fornecedores até a venda para os clientes, atualizando eficientemente a quantidade de produtos estocados.

## 2. Domínio do Projeto

O domínio deste projeto é a gestão de estoque em um supermercado. A gestão mais eficiente do estoque é muito importante devido à quantidade de transações, mudanças corriqueiras no número de itens e a diversidade de produtos. O sistema deve gerir um banco de dados de produtos que se diferenciam em atributos como: preço, data de validade e detalhes do fornecedor, rastreando compras e vendas com atualizações no estoque.

O modelo cria um sistema que pode registrar produtos, gerenciar fornecedores e acompanhar as compras e vendas. Será possível saber o que está disponível, o que falta e o que precisa ser reposto. Esse sistema ajuda na operação diária do supermercado e garante que os produtos estejam sempre disponíveis para os clientes.

### Requisitos de Dados

As principais entidades:

- **Produto:** código, nome, descrição, preço, custo, data de validade
- **Fornecedor:** nome, endereço, contato
- **Compra:** número total de produtos e preços
- **Venda:** data, quantidade vendida e valor total

---

## 3. Modelo Conceitual UML Inicial

![image](https://github.com/user-attachments/assets/4eec24c6-944e-4c98-9037-722691142406)


---

## 4. Integração da Inteligência Artificial

Foi utilizado o ChatGPT para obter sugestões de melhoria do projeto. O prompt usado foi:

> “O que podemos fazer para melhorar o projeto de acordo com a proposta: [...]”

### Sugestões da IA:

#### 1. Associação de Classes (Association Class)
- **ItemVenda:** já está modelada corretamente como associação entre Venda e Produto.
- **ItemCompra:** sugerida para registrar atributos como quantidade, preço e data de entrega.

#### 2. Qualificadores
- **Fornecedor - Produto:** uso de código específico do fornecedor como qualificador.

#### 3. Composição
- **Produto - Categoria:** usar composição (produto depende da existência da categoria).

---

## 5. Modelo UML Conceitual Final
![image](https://github.com/user-attachments/assets/917eff13-940b-47ed-8866-22ba4e953a28)



Após análise, foram feitas as seguintes alterações:

- Relações de **composição** entre Produto e Categoria, Produto e Estoque
- Adição das associações de classes **ItemVenda** e **ItemCompra**
- **Não** uso de qualificadores (atributo NIPC e lista de produtos são suficientes)

---

## 6. Modelo Conceitual Corrigido
<img width="424" alt="image" src="https://github.com/user-attachments/assets/fb1a40e6-612a-4782-9b41-dd9e543a6050" />

- Classe Estoque foi removida (único atributo: quantidade, que passou a estar em Produto)
- Revisão de multiplicidades
- Atributos redundantes removidos
- Correções em generalizações
- Adição de associação com atributo "Prazo de Entrega"

---

## 7. Esquema Relacional Inicial

```sql
PessoaFuncionario(NIF, Nome, DataNascimento, Cargo, Salario)
PessoaCliente(NIF, Nome, DataNascimento, Morada)
Fornecedor(NIPC, Nome, Morada, Telefone, Email)
Fornece(NIPC -> Fornecedor.NIPC, Codigo -> Produto.Codigo, PrazoEntrega)
Produto(Codigo, Descricao, Custo, Categoria -> Categoria.Tipo, Fornecedor -> Fornecedor.NIPC, Quantidade)
Compra(IDCompra, DataCompra, QuantidadeCompra, ValorTotal, Fornecedor -> Fornecedor.NIPC)
ItemCompra(CodigoItem -> Produto.Codigo, IDCompra ->Compra.IDCompra, PrecoUnidade, Quantidade)
Venda(IDVenda, IDCliente -> PessoaCliente.NIF, Vendedor ->PessoaFuncionario.NIF, DataVenda, ValorTotal, MetodoPagamento -> MetodoPagamento.Tipo)
MetodoPagamento(Tipo, Status)
ItemVenda(CodigoItem -> Produto.Codigo, IDVenda -> Venda.IDVenda, PrecoUnidade, Quantidade)
```


---

## 8. Integração com IA (Esquema Relacional)

**Sugestões não implementadas:**
- Inclusão de `IDItemCompra` e `IDItemVenda`: considerados desnecessários no contexto.
- Outras alterações foram mais conceituais e não adotadas.

---

## 9. Análise de Dependências Funcionais e Formas Normais

**Exemplo: PessoaFuncionario**
- Dependências:
  - `NIF → Nome, DataNascimento, Morada, Cargo`
  - `Cargo → Salario`
- **Problema:** A relação não está em 3FN nem BCNF, pois `Cargo` não é superchave, mas determina `Salario`.
- **Decomposição sugerida:**
  - `PessoaFuncionario(NIF, DataNascimento, Morada, Cargo)`
  - `CargoSalario(Cargo, Salario)`

**Observação:** Outras entidades como `Produto`, `Fornecedor`, `Venda`, etc. estão em 3FN/BCNF.

---

## 10.1 Integração com IA (Normalização)

- Correção sugerida:
  - "O problema não está na chave primária `NIF`, mas na dependência transitiva envolvendo `Cargo`."
  - "A relação não está na BCNF porque `Cargo` não é superchave, mas determina o `Salario`."

---

## 11. Criação da Base de Dados em SQL

- **Implementação:** Utilização do `sqlite3`.
- **Foco:** Prioridade às `constraints`.
- **Recursos usados:**
  - `ON UPDATE CASCADE`
  - `ON DELETE SET NULL` (alterado depois para `ON DELETE CASCADE`)

**Alterações após uso da IA:**
- Tipo do campo `NIF` alterado de `TEXT` para `INTEGER`.
- `ON DELETE SET NULL` foi substituído por `ON DELETE CASCADE` nas relações:
  - `ItemVenda`, `ItemCompra`, `Fornece`
- Na tabela `MetodoPagamento`, foi adicionada uma **chave composta** com `Status` para permitir múltiplos tipos.

---

## 12. População da Base de Dados

**Etapas:**
1. Primeira etapa: inserção manual de dados + ferramentas online.
   - Arquivo: `populate1.sql`
2. Segunda etapa: uso da IA (ChatGPT) para gerar 10 registros por tabela.
   - Arquivo: `populate2.sql`

---

## 13. Integração com IA

- **IA auxiliou principalmente em:**
  - Geração e revisão de código SQL.
  - População da base de dados (dados plausíveis, variados e em quantidade).
- **Menor utilidade:**
  - Etapas iniciais da modelagem relacional (modelo conceitual e mapeamento).
