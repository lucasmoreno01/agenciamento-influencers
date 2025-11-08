# agenciamento-influencers

Este repositório contém o script SQL completo para criação, indexação e população de um banco de dados relacional voltado à gestão de influenciadores, marcas, plataformas e contratos publicitários.

## 🧱 Estrutura do Banco

O banco foi modelado com foco em integridade referencial, utilizando chaves primárias, estrangeiras e constraints de validação.  
Principais tabelas:
- **TB_INFLUENCER:** dados básicos dos influenciadores.  
- **TB_PLATAFORMA:** plataformas de mídia social.  
- **TB_MARCA:** informações das marcas contratantes.  
- **TB_CONTRATO:** contratos celebrados entre marcas e influenciadores.  
- **RL_INFLUENCER_PLATAFORMA:** métricas de desempenho por plataforma.  
- **RL_INFLUENCER_CONTRATO:** associações entre influenciadores e contratos.

## ⚙️ Requisitos
- PostgreSQL instalado (versão 12 ou superior).  
- Cliente SQL (pgAdmin ou psql).  
- Usuário com permissão para criar bancos e objetos.

## 🚀 Como executar

1. **Criar o banco de dados**
   ```sql
   CREATE DATABASE influencers_db;
   \c influencers_db;

2. **Executar Script**
    - Via PSQL
      ```
      psql -U seu_usuario -d influencers_db -h seu_host -f influencers_schema.sql
      ```
    - Via PGADMIN
        - Abra o Query Tool conectado ao banco influencers_db.
        - Cole o conteúdo de influencers_schema.sql e clique em Executar (▶️).
        - 
  ## 📁 Estrutura do Script

  O arquivo influencers_schema.sql está dividido em três seções principais:

1. Criação do Schema – definição das tabelas e constraints.

2. Indexação – criação de índices auxiliares.

3. População – inserção de dados de teste (influenciadores, marcas, contratos e métricas).
