# Desafio CB Labs

Este projeto é um desafio proposto pelo Coco Bambu, que consiste na criação de um Data Lake para armazenar dados brutos provenientes de APIs, com posterior inserção em um banco de dados relacional, aplicando as melhores práticas de Engenharia de Dados.

## Estrutura do Projeto

- `main.ipynb`: Notebook Jupyter responsável por validar toda a lógica aplicada no desafio.
- `model.sql`: Script SQL para criação do banco de dados e das tabelas normalizadas, refletindo a estrutura dos dados extraídos do JSON.
- `requirements.txt`: Lista de dependências Python necessárias para executar o notebook.
- `respostas.md`: Documento com respostas detalhadas das perguntas do desafio.
- `kanban.md`: Quadro Kanban com o acompanhamento das tarefas do projeto.
- `diagrama.png`: Diagrama ilustrando a modelagem do banco de dados relacional.

## Como executar

### Passo 1: Acessar o Data Lake no Google Cloud Storage
1. O Data Lake está hospedado no Google Cloud Storage. Você pode acessá-lo através do seguinte link:
   [CB Labs Data Lake](https://console.cloud.google.com/storage/browser/cblabs_datalake/bronze/res_guest_checks/2024/07/24;tab=objects?authuser=0&inv=1&invt=Ab3o-Q&project=elegant-skein-464817-t0&pageState=(%22StorageObjectListTable%22%20(%22f%22:%22%255B%255D%22))&prefix=&forceOnObjectsSortingFiltering=false).
2. Verifique que o arquivo `ERP.json` está localizado no caminho `bronze/res_guest_checks/2024/07/24/ERP.json`.

### Passo 2: Configuração do banco de dados MySQL
1. Crie o banco de dados e as tabelas no MySQL utilizando o script SQL disponível no arquivo `model.sql`.
2. Verifique se tabelas foram criadas.

### Passo 3: Instalar dependências Python

Recomenda-se o uso de um ambiente virtual. Instale as dependências com:

```bash
pip install -r requirements.txt
```

### Passo 4: População com Python

1. No arquivo Jupyter Notebook `main.ipynb`, configure a conexão com o MySQL utilizando as credenciais apropriadas.
2. O script Python faz a leitura do arquivo `ERP.json` diretamente do Data Lake e insere as informações nas tabelas do MySQL utilizando conexões via `pymysql`.

### Passo 5: Visualização dos dados

O notebook também permite consultar e exibir os dados inseridos no banco, utilizando pandas.

---

## Requisitos

- Python 3.12+
- MySQL Server
- Acesso ao Google Cloud Storage (para baixar o JSON)

---

Para mais detalhes sobre a modelagem, decisões técnicas e estrutura dos dados, consulte o arquivo `respostas.md`.
