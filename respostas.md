# Respostas 

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
O `guestChecks` atua como a entidade central do pedido. `taxes` e `detailLines` são diretamente associados a cada pedido. O conteúdo específico de uma linha de detalhe é definido pelos objetos aninhados (como `menuItem` ou outros tipos).
---  
## D1.3: Descreva a abordagem escolhida em detalhes. Justifique a escolha.
