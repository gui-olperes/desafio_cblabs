# Respostas 
---
## D1.1: Descreva o esquema JSON correspondente ao exemplo acima.

### **Estrutura do Esquema JSON**

O arquivo `ERP.json` organiza os dados de transações de um restaurante em um formato hierárquico, combinando objetos e arrays.

**Visão Geral:**

O documento JSON inicia com um objeto principal que contém:
* **`curUTC`**: Uma string indicando a data e hora de referência em fuso horário UTC.
* **`locRef`**: Uma string que identifica a unidade (loja) de onde os dados se originam.
* **`guestChecks`**: Um array fundamental que agrupa todos os pedidos de clientes.

**Detalhes dos Pedidos (`guestChecks`):**

Cada elemento dentro do array `guestChecks` é um objeto que representa um pedido. Estes objetos incluem informações essenciais do pedido, como:
* Um identificador único (`guestCheckId`).
* O número da conta (`chkNum`).
* Flags de status (`clsdFlag`).
* Vários valores totalizados do pedido (`subTtl`, `chkTtl`, `payTtl`, etc.).

Dentro de cada pedido, encontramos subestruturas em formato de arrays para mais detalhes:
* **`taxes`**: Uma lista de objetos, onde cada um descreve um imposto específico aplicado ao pedido.
* **`detailLines`**: Uma lista de objetos que representam as diversas linhas de um pedido.

**Aninhamentos Chave (`detailLines`):**

Cada linha de detalhe dentro de `detailLines` é um objeto identificado por `guestCheckLineItemId`. Essas linhas são notáveis por sua natureza polimórfica, ou seja, podem conter diferentes tipos de objetos aninhados para descrever o item:
* Mais comumente, um `menuItem`, que detalha um produto do cardápio com atributos como `miNum` (número do item de menu), `modFlag` (indicador de modificação), e `prcLvl` (nível de preço).
* No entanto, o design do sistema prevê que essas linhas também possam abrigar objetos para `discount` (descontos), `serviceCharge` (taxas de serviço), `tenderMedia` (formas de pagamento) ou `errorCode` (erros).

**Tipos de Dados Representados:**

Os dados no JSON utilizam tipos variados:
* **Strings:** Para identificadores textuais, datas (como `opnBusDt`), e descrições.
* **Números:** Para IDs, quantidades, valores monetários (inteiros e decimais).
* **Booleanos:** Para indicadores de verdadeiro/falso (`clsdFlag`).
* **Nulos:** Para campos que podem estar vazios ou não se aplicam.

---  
## D1.3: Descreva a abordagem escolhida em detalhes. Justifique a escolha.
