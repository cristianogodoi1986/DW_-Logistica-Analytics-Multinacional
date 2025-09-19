# 🌍 Projeto: Logistica Analytics Multinacional

Este repositório contém o script completo de um projeto de **Data Warehouse** voltado para operações logísticas em uma empresa multinacional, com dados de **Brasil, EUA, Alemanha e Japão**.

> 🧠 **Banco de dados:** SQL Server 2021  
> 👨‍💻 **Criado por:** Cristiano de Godoi  
> 🎓 **Curso:** Data Analytics 12 – Yto Nihon Treinamentos  
> 📅 **Data de criação:** 10/08/2025

---

## 🚀 Objetivo

Desenvolver uma base analítica robusta para monitorar e otimizar operações logísticas globais, utilizando modelagem dimensional, boas práticas de staging e visualizações estratégicas.

---

## 🧱 Estrutura do Projeto

- **Schema `staging`**: ingestão e preparação dos dados brutos
- **Schema `dw`**: estrutura analítica com tabelas fato e dimensões

### 🗂️ Componentes incluídos

- Tabelas de **dimensões**: país, produto, tempo, centro de distribuição
- Tabela **fato**: movimentações logísticas
- Scripts de **população** com dados simulados
- **Views analíticas** para consumo direto em ferramentas de BI
- Exemplos de **SELECTs estratégicos** para análise de desempenho

---

## 🛠️ Scripts incluídos

- `create_database.sql`: Criação do banco `Logistica_Analytics_Multinacional`
- `create_schema.sql`: Criação dos schemas `staging` e `dw`
- `create_tables.sql`: Estrutura das tabelas
- `populate_data.sql`: Carga de dados simulados
- `views.sql`: Criação de views analíticas
- `select_examples.sql`: Exemplos de consultas analíticas

---

## 📈 Boas práticas aplicadas

- Separação clara entre **camadas de ingestão e análise**
- Uso de **chaves substitutas** nas dimensões
- Scripts **idempotentes** para staging
- Controle de **Slowly Changing Dimensions (SCD Tipo 2)**
- Organização por **país e centro logístico**

---

## 🧪 Como usar

1. Clone o repositório
2. Execute os scripts na ordem:
   - `create_database.sql`
   - `create_schema.sql`
   - `create_tables.sql`
   - `populate_data.sql`
   - `views.sql`
3. Explore os dados com os exemplos em `select_examples.sql`
4. Conecte sua ferramenta de BI (ex: Power BI, Tableau) e comece a analisar!

---

## 📬 Contato

**Cristiano de Godoi**  
📧 cristiano.godoi10@hotmail.com
🔗 [LinkedIn]([https://linkedin.com/in/seuusuario](https://www.linkedin.com/in/cristiano-godoi-franciscano-25508683/)

---
