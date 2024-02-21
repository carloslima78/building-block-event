# Building Block de Eventos Baseado em SNS e SQS

## Recursos

Os recursos definidos neste código são responsáveis por criar as filas SQS, o tópico SNS, as assinaturas do tópico para as filas, e as políticas de permissão.

### aws_sqs_queue (DLQ)

Este recurso cria as filas SQS de DLQ com base nos nomes definidos.

- **Nome**: `${var.queue_names[count.index]}-dlq`
- Cada fila de DLQ está associada à fila correspondente da `queue_names`.

### aws_sqs_queue (Filas Principais)

Este recurso cria as filas SQS principais com a política de redrive para enviar mensagens para a DLQ após 2 tentativas.

- **Nome**: `var.queue_names[count.index]`
- **Política de Redrive**: As mensagens serão redirecionadas para a DLQ após 2 tentativas de processamento.

### aws_sns_topic

Este recurso cria o tópico SNS com o nome definido.

- **Nome**: `var.sns_topic_name`

### aws_sns_topic_subscription

Este recurso cria as assinaturas do tópico SNS para as filas SQS, com base nos filtros definidos.

- Cada fila SQS tem uma assinatura no tópico SNS com seu respectivo filtro de `eventType`.

### aws_sqs_queue_policy

Este recurso cria a política de permissão para o tópico SNS enviar mensagens para as filas SQS.

- A permissão é concedida ao tópico SNS para enviar mensagens para as filas SQS.

