# Building Block de Eventos Baseado em SNS e SQS

Este building block consiste em uma receita para padronizar eventos sincronizados por fanout usando o Amazon Simple Notification Service (SNS) e o Amazon Simple Queue Service (SQS). Cada componente desempenha um papel vital na arquitetura:

- **Tópico SNS**: Cria o tópico SNS para facilitar a comunicação entre as filas SQS e os produtores de eventos, garantindo um modelo de fanout para propagar eventos para múltiplos consumidores de forma eficiente.

- **Filas SQS**: Cria as filas SQS principais assinantes do tópico SNS, com políticas de redrive para direcionar mensagens para a DLQ após um número específico de tentativas de processamento.

- **Filas SQS (DLQ)**: Cria as filas SQS de Dead Letter Queue (DLQ) associadas às filas principais, permitindo o armazenamento de mensagens que falharam no processamento.
  
## Recursos

Os recursos definidos neste código são responsáveis por criar as filas SQS, o tópico SNS, as assinaturas do tópico para as filas, e as políticas de permissão.

### Variáveis

- **queue_names**: Variável que define os nomes das filas SQS a serem criadas.
  - **Descrição**: Nomes das filas SQS.
  - **Valor padrão**: `["order", "payment", "shipment"]`

- **filter_policies**: Variável que define os filtros para cada assinatura das filas.
  - **Descrição**: Filtros para cada assinatura das filas SQS.
  - **Valor padrão**:
    ```json
    {
      "order":    { "eventType": ["order_placed"] },
      "payment":  { "eventType": ["payment_received"] },
      "shipment": { "eventType": ["shipment_dispatched"] }
    }
    ```

- **sns_topic_name**: Variável que define o nome do tópico SNS.
  - **Descrição**: Nome do tópico SNS.
  - **Valor padrão**: `"confirmed_sale"`

### `aws_sqs_queue` (DLQ)

Este recurso cria as filas SQS de DLQ com base nos nomes definidos.

- **Nome**: `${var.queue_names[count.index]}-dlq`
- Cada fila de DLQ está associada à fila correspondente da `queue_names`.

### `aws_sqs_queue` (Filas Principais)

Este recurso cria as filas SQS principais com a política de redrive para enviar mensagens para a DLQ após 2 tentativas.

- **Nome**: `var.queue_names[count.index]`
- **Política de Redrive**: As mensagens serão redirecionadas para a DLQ após 2 tentativas de processamento.

### `aws_sns_topic`

Este recurso cria o tópico SNS com o nome definido.

- **Nome**: `var.sns_topic_name`

### `aws_sns_topic_subscription`

Este recurso cria as assinaturas do tópico SNS para as filas SQS, com base nos filtros definidos.

- Cada fila SQS tem uma assinatura no tópico SNS com seu respectivo filtro de `eventType`.

### `aws_sqs_queue_policy`

Este recurso cria a política de permissão para o tópico SNS enviar mensagens para as filas SQS.

- A permissão é concedida ao tópico SNS para enviar mensagens para as filas SQS.

## Testando as Filas DLQ

Para testar o funcionamento das filas DLQ, vamos seguir os passos abaixo:

- **Processar a mensagem até falhar**:
  - Vamos produzir 2 ou mais mensagens para uma das filas, vamos utilizar como exemplo a fila **payment**.
  - No menu à esquerda, clique em **Enviar e receber mensagens** e depois em **Ver mensagens**.
  - Isso simula um consumidor da fila pegando a mensagem para processamento.
  - Uma das mensagens deve aparecer na tela. Clique em "Iniciar busca de mensagens" e depois em "Interromper a busca". Repita esse passo mais 3 vezes (um total de 4 vezes).
  - Após a quarta tentativa, a mensagem será redirecionada automaticamente para a DLQ **payment.dlq** associada à **payment**.

O procedimento acima simula o processamento com falhas no consumo da mensagem até que ela seja redirecionada para a fila DLQ após o número de tentativas definido pela variável maxReceiveCount.
