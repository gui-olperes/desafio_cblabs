# Respostas D1

## D1.1: Descreva o esquema JSON correspondente ao exemplo acima.

### **Descrição do Esquema JSON**

O JSON fornecido (`ERP.json`) estrutura dados de transações de restaurante de forma hierárquica, utilizando objetos e arrays.

**Estrutura Principal:**
O documento começa com um objeto que contém:
* `curUTC`: Data e hora em formato UTC.
* `locRef`: Identificador do local ou loja.
* `guestChecks`: Um array, onde cada elemento é um objeto que representa um pedido de cliente.

**Detalhes do Pedido (`guestChecks`):**
Cada pedido (`guestCheck`) é um objeto que inclui:
* Identificadores como `guestCheckId` e `chkNum`.
* Status e informações de tempo (`clsdFlag`, `opnBusDt`).
* Valores totais (`subTtl`, `chkTtl`, `payTtl`, etc.).

Aninhados dentro de cada pedido, encontramos dois arrays importantes:
* `taxes`: Contém objetos que detalham os impostos aplicados ao pedido.
* `detailLines`: Lista de objetos que representam as linhas de detalhe do pedido.

**Linhas de Detalhe (`detailLines`) e Polimorfismo:**
Cada objeto dentro do array `detailLines` é uma linha de detalhe específica. Essas linhas podem conter diferentes tipos de **instâncias** aninhadas, como:
* Um `menuItem`, que fornece detalhes sobre um item do cardápio (`miNum`, `modFlag`, `prcLvl`).
* Ou, como o sistema prevê, pode conter instâncias de `discount`, `serviceCharge`, `tenderMedia`, ou `errorCode`, dependendo da natureza da linha.

**Tipos de Dados Comuns:**
Os campos no JSON utilizam tipos como:
* **Strings:** Para textos e datas (ex: `locRef`, `opnBusDt`).
* **Números:** Para IDs, quantidades e valores monetários (ex: `guestCheckId`, `subTtl`, `taxRate`).
* **Booleanos:** Para indicadores verdadeiro/falso (ex: `clsdFlag`, `modFlag`).
* **Nulos:** Para campos opcionais sem valor (ex: `nonTxblSlsTtl`, `balDueTtl`).

**Relações Chave:**
* O `guestChecks` atua como a entidade central do pedido. `taxes` e `detailLines` são diretamente associados a cada pedido. O conteúdo específico de uma linha de detalhe é definido pelos objetos aninhados (como `menuItem` ou outros tipos). 
---  
## D1.3: Descreva a abordagem escolhida em detalhes. Justifique a escolha.

Para transformar o arquivo JSON de pedidos em um modelo de banco de dados, escolhi uma estrutura relacional **organizada e detalhada**, otimizada para as **operações diárias de um restaurante** e para ser a base de dados principal.

#### **1. Objetivo Principal: Registrar Operações Diárias**

O JSON que recebi (`ERP.json`) representa pedidos individuais, itens, e impostos – dados que mudam a cada nova venda. Para "fazer sentido para operações de restaurante", o banco de dados precisa ser muito bom em:
* **Guardar dados sem erros:** Garantir que cada pedido e cada item estejam corretos e completos.
* **Registrar rápido:** Inserir novos pedidos e detalhes de forma ágil, sem atrasar o caixa.
* **Lidar com muitos dados:** O sistema deve funcionar bem para uma grande rede de restaurantes, com milhares de pedidos por dia.

Por isso, optei por um modelo **relacional normalizado**. Isso significa que quebrei as informações em pequenas "peças" (tabelas) e as conectei.

#### **2. Como Quebrei o JSON em Tabelas (A Abordagem Detalhada)**

Imaginei as principais partes do JSON como minhas tabelas:

* **Tabela `LOCAIS`**:
    * **O que é:** Guarda o nome e outros dados de cada restaurante (`locRef`).
    * **Por que:** Uma rede de restaurantes tem muitas lojas. Separar os dados das lojas ajuda a gerenciar tudo e a ver o desempenho de cada uma sem repetir as informações.

* **Tabela `PEDIDOS` (`guest_checks`):**
    * **O que é:** É a tabela principal, onde fica o resumo de cada pedido (ID, número da conta, totais, horários).
    * **Por que:** É o coração do sistema de pedidos. Tudo relacionado a um pedido se conecta a ela.

* **Tabela `IMPOSTOS` (`taxes`):**
    * **O que é:** Guarda os detalhes dos impostos de cada pedido.
    * **Por que:** Um pedido pode ter vários impostos. Separar isso em uma tabela própria evita bagunça e permite adicionar novos tipos de impostos facilmente no futuro.

* **Tabela `LINHAS_DETALHE` (`detail_lines`):**
    * **O que é:** Lista cada item ou evento dentro de um pedido (ex: um prato, um desconto, uma taxa).
    * **Por que:** Essencial para detalhar o que foi consumido.

#### **3. O "Polimorfismo" das Linhas de Detalhe (O Segredo do `detailLines`)**

A parte mais "complicada" do JSON é que uma "linha de detalhe" pode ser várias coisas diferentes: um item do cardápio (`menuItem`), um `discount` (desconto), uma `serviceCharge` (taxa de serviço), etc.

* **Como Resolvi:** Em vez de ter uma tabela `LINHAS_DETALHE` gigante com colunas para `menuItem`, `discount`, `serviceCharge` (e muitas delas vazias!), criei **tabelas separadas para cada tipo**:
    * `ITENS_MENU` (`menu_items`)
    * `DESCONTOS` (`discounts`)
    * `TAXAS_SERVICO` (`service_charges`)
    * `MEIOS_PAGAMENTO` (`tender_media`)
    * `ERROS_PEDIDO` (`error_codes`)

* **Por que essa escolha:**
    * **Organização e Limpeza:** As tabelas ficam mais "limpas", sem muitas colunas vazias. Cada tipo de informação tem seu lugar.
    * **Flexibilidade:** Se no futuro o restaurante adicionar um novo tipo de "detalhe" (como um "vale-presente"), é só criar uma nova tabela para ele, sem mexer nas tabelas existentes.
    * **Evitar confusão:** Fica claro que um item é um item, e um desconto é um desconto, com seus próprios dados.

#### **4. O Impacto da Minha Abordagem**

* **Dados Confiáveis:** Menos chance de erros ou informações duplicadas.
* **Pronto para o Crescimento:** O banco de dados pode lidar com o aumento de pedidos e lojas sem perder o desempenho.
* **Base Sólida para Análise:** Os dados ficam bem organizados para que, no futuro, a equipe de inteligência de negócios possa criar seus relatórios de forma mais fácil e confiável.

Essa abordagem garante que o banco de dados sirva bem às operações diárias do restaurante e esteja preparado para as necessidades de dados da rede, de forma simples e eficiente.
---

# Respostas D2

## D2.1: Por que armazenar as respostas das APIs no Data Lake?

Armazenar as respostas brutas das APIs em um Data Lake é crucial por:

* **Preservação de Histórico:** Garante um registro completo e imutável de todos os dados recebidos para auditorias, reprocessamento e análises retrospectivas.

* **Flexibilidade para o Futuro:** Permite que novos casos de uso ou modelos (incluindo Machine Learning) sejam desenvolvidos, acessando os dados em sua forma mais original.

* **Resiliência a Mudanças de Esquema:** A camada bruta absorve alterações no esquema da API (ex: campos adicionados/renomeados) sem quebrar imediatamente a ingestão, dando tempo para adaptar as etapas de processamento.

* **Depuração Eficiente:** Facilita a investigação e correção de erros, comparando os dados brutos da API com as saídas das etapas de processamento.
---

## D2.2: Como você armazenaria os dados? Crie uma estrutura de pastas capaz de armazenar as respostas da API. Ela deve permitir manipulação, verificações, buscas e pesquisas rápidas.

```
gs://cblabs_datalake/

├── bronze/ # Dados Brutos: Recebidos diretamente das APIs, inalterados.
│   ├── bi_fiscal_invoice/                  
│   ├── res_guest_checks/                   
│   ├── org_charge_back/                    
│   ├── trans_transactions/                 
│   └── inv_cash_management_details/        
│       # Nota: Os arquivos aqui são particionados por data (ano/mês/dia) internamente para otimização.
│
├── silver/ # Dados Refinados: Limpos, padronizados e estruturados (geralmente em Parquet).
│       # Nota: Dados temporais aqui também são particionados por data (ano/mês/dia) internamente.
│
└── gold/ # Dados Curados: Agregados e modelados prontos para consumo.
│
└── logs/

```
* para melhor visualização, acesse o bucket na gs:
```
https://console.cloud.google.com/storage/browser/cblabs_datalake/bronze/res_guest_checks/2024/07/24?authuser=0&inv=1&invt=Ab3owA&project=elegant-skein-464817-t0&pageState=(%22StorageObjectListTable%22 (%22f%22:%22%255B%255D%22))
```

Justificativa:

* Divisão Lógica por Camadas (Bronze, Silver, Gold): Organiza o ciclo de vida do dado, desde o formato bruto até o consumo final.

* Particionamento por Data (implícito): A organização interna por ano/mês/dia é fundamental para buscas e pesquisas rápidas, otimizando o volume de dados lidos e reduzindo custos.

* Facilidade de Manipulação e Verificação: A estrutura permite isolar e reprocessar dados de fontes ou períodos específicos, facilitando a depuração.

* Escalabilidade e Organização: Suporta o crescimento contínuo do volume de dados e a adição de novas fontes sem comprometer a organização ou a performance.

* Logs Dedicados: Uma área separada para logs de execução e acesso é crucial para monitoramento e segurança.

---

## D2.3: Considere que a resposta do endpoint getGuestChecks foi alterada, por exemplo, guestChecks.taxes foi renomeado para guestChecks.taxation. O que isso implicaria?

A alteração implicaria diretamente em:

* **Falha da Pipeline de Dados:** Os scripts que esperam o campo taxes não o encontrarão mais nos novos dados, causando erros e interrompendo o fluxo de dados para as camadas subsequentes.

* **Necessidade de Atualização e Reteste:** O código de ETL/ELT precisará ser modificado para reconhecer o novo nome do campo. Isso exige um reteste completo de todo o pipeline para garantir que os dados sejam processados corretamente.

* **Impacto em produção nos Relatórios e Análises:** análises e relatórios que dependem desse campo podem exibir informações incompletas ou incorretas até que o pipeline seja corrigido e os dados reprocessados.

* **Desafio de Evolução de Esquema:** Este cenário destaca a importância de ter um planejamento para lidar com mudanças na estrutura dos dados da fonte.
