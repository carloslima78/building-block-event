# Building Block de Eventos Baseado em SNS e SQS

Este building block consiste em uma receita para padronizar eventos sincronizados por fanout usando o Amazon Simple Notification Service (SNS) e o Amazon Simple Queue Service (SQS). Cada componente desempenha um papel vital na arquitetura:

- **Tópico SNS**: Cria o tópico SNS para facilitar a comunicação entre as filas SQS e os produtores de eventos, garantindo um modelo de fanout para propagar eventos para múltiplos consumidores de forma eficiente.

- **Filas SQS**: Cria as filas SQS principais assinantes do tópico SNS, com políticas de redrive para direcionar mensagens para a DLQ após um número específico de tentativas de processamento.

- **Filas SQS (DLQ)**: Cria as filas SQS de Dead Letter Queue (DLQ) associadas às filas principais, permitindo o armazenamento de mensagens que falharam no processamento.
  
## Recursos

Os recursos definidos neste código são responsáveis por criar as filas SQS, o tópico SNS, as assinaturas do tópico para as filas, e as políticas de permissão.

### Arquivo `variables.tf` - Documentação

Este arquivo `variables.tf` é utilizado para definir as variáveis necessárias para a criação de recursos na AWS (Amazon Web Services) dentro de um ambiente de arquitetura de mensageria, como SNS (Simple Notification Service) e SQS (Simple Queue Service). Cada bloco de variável tem um propósito específico, detalhado a seguir:

---

#### `aws_region`

- **Objetivo**: Define a região da AWS onde os recursos serão criados.
- **Descrição**: Esta variável é utilizada para especificar a região geográfica da AWS onde os serviços como SNS e SQS serão implantados.
- **Valor Padrão**: "us-east-1"
  
---

#### `sns_topic`

- **Objetivo**: Define o nome do tópico SNS a ser criado.
- **Descrição**: O tópico SNS é uma entidade central em mensageria de pub/sub (publicação/assinatura) da AWS. Esta variável define o nome do tópico que será utilizado para notificações.
- **Valor Padrão**: "confirmed_sale"
  
---

#### `is_fifo_topic`

- **Objetivo**: Indica se o tópico SNS deve ser FIFO (First-In-First-Out) ou não.
- **Descrição**: Quando esta variável é configurada como `true`, o tópico SNS será configurado para seguir a ordem de chegada das mensagens (FIFO), garantindo uma entrega ordenada.
- **Tipo**: Booleano (`true` ou `false`)
- **Valor Padrão**: `false`

---

#### `sqs_queues`

- **Objetivo**: Define os nomes das filas SQS a serem criadas.
- **Descrição**: As filas SQS são utilizadas para armazenar mensagens em um ambiente de filas de mensagens. Esta variável especifica os nomes das filas que serão criadas.
- **Valor Padrão**: ["order", "payment", "shipment"]

---

#### `is_fifo_queues`

- **Objetivo**: Indica se as filas SQS devem ser FIFO (First-In-First-Out) ou não.
- **Descrição**: Similar ao `is_fifo_topic`, esta variável define se as filas SQS devem seguir a ordem de chegada das mensagens (FIFO) ou não.
- **Tipo**: Lista de booleanos (`true` ou `false`) para cada fila especificada em `sqs_queues`.
- **Valor Padrão**: [false, false, false]

---

#### `filter_policies`

- **Objetivo**: Define os filtros de política para cada assinatura nas filas SQS.
- **Descrição**: Esta variável é utilizada para especificar os filtros de política para diferentes tipos de mensagens que serão direcionadas para cada fila SQS.
- **Valor Padrão**: 
  ```json
  {
    "order":    { "eventType": ["order_placed"] },
    "payment":  { "eventType": ["payment_received"] },
    "shipment": { "eventType": ["shipment_dispatched"] }
  }

Isso significa que as mensagens com eventos de order_placed serão enviadas para a fila order, mensagens com eventos de payment_received para a fila payment, e mensagens com eventos de shipment_dispatched para a fila shipment.

### Arquivo `main.tf` - Documentação

Este arquivo `main.tf` contém a configuração dos recursos na AWS (Amazon Web Services) para criar um ambiente de mensageria utilizando SNS (Simple Notification Service) e SQS (Simple Queue Service). Cada bloco de recurso tem um propósito específico, detalhado a seguir:

---

#### `provider "aws"`

- **Objetivo**: Configura o provedor AWS para definir a região onde os recursos serão criados.
- **Descrição**: Este bloco define o provedor AWS e utiliza a variável `aws_region` para configurar a região na qual os recursos serão provisionados.
  
---

#### `resource "aws_sns_topic" "topic"`

- **Objetivo**: Cria o tópico SNS.
- **Descrição**: Este recurso cria o tópico SNS com o nome definido pela variável `sns_topic`. Se `is_fifo_topic` for `true`, o tópico será FIFO (First-In-First-Out).
  
---

#### `resource "aws_sqs_queue" "queue"`

- **Objetivo**: Cria as filas SQS principais para assinantes do tópico SNS.
- **Descrição**: Este recurso cria as filas SQS principais para cada nome especificado em `sqs_queues`. Se `is_fifo_queues` for `true`, a fila será FIFO.
- **Configuração adicional**: Define uma política de redirecionamento (`redrive_policy`) para direcionar mensagens para uma Dead Letter Queue (fila de mensagens inválidas ou não processáveis) após duas tentativas de processamento mal sucedidas.

---

#### `resource "aws_sqs_queue" "dlq"`

- **Objetivo**: Cria as filas SQS de Dead Letter Queue (DLQ) para cada fila assinante.
- **Descrição**: Este recurso cria uma fila de DLQ para cada fila principal, para onde as mensagens inválidas ou não processáveis serão redirecionadas.

---

#### `resource "aws_sns_topic_subscription" "queue_subscription"`

- **Objetivo**: Cria as inscrições das filas SQS no tópico SNS.
- **Descrição**: Este recurso configura as inscrições das filas SQS no tópico SNS para que as mensagens sejam entregues às filas corretas.
- **Configuração adicional**: Utiliza `filter_policy` para filtrar mensagens com base nos critérios definidos em `filter_policies` para cada fila.

---

#### `resource "aws_sqs_queue_policy" "queue_policy"`

- **Objetivo**: Aplica políticas às filas SQS para permitir o envio de mensagens do tópico SNS.
- **Descrição**: Este recurso aplica políticas às filas SQS para permitir que o tópico SNS envie mensagens para essas filas.
- **Configuração adicional**: Define uma política que permite que o serviço SNS (`sns.amazonaws.com`) envie mensagens para as filas SQS especificadas, com base no `aws:SourceArn` do tópico SNS correspondente.

---

Este arquivo `main.tf` é responsável por configurar a infraestrutura de mensageria na AWS, incluindo a criação de tópicos SNS, filas SQS principais e suas filas de DLQ, inscrições das filas no tópico SNS e políticas para permitir o envio de mensagens entre esses recursos. Essa configuração proporciona um sistema robusto de mensageria capaz de lidar com diferentes tipos de mensagens e cenários de processamento.

### Arquivo `output.tf` - Documentação

Este arquivo `output.tf` contém as definições de saída (outputs) que fornecem informações sobre os recursos criados no ambiente de mensageria na AWS. Cada output é detalhado a seguir:

---

#### `output "topic_arn"`

- **Objetivo**: Output para o ARN do tópico SNS.
- **Descrição**: Este output fornece o Amazon Resource Name (ARN) do tópico SNS criado.
  
---

#### `output "queue_ids"`

- **Objetivo**: Output para os IDs das filas SQS principais assinantes do tópico SNS.
- **Descrição**: Este output fornece uma lista dos IDs das filas SQS principais que são assinantes do tópico SNS.
  
---

#### `output "dlq_ids"`

- **Objetivo**: Output para os IDs das filas SQS de Dead Letter Queue (DLQ).
- **Descrição**: Este output fornece uma lista dos IDs das filas SQS de DLQ criadas para cada fila principal.

---

#### `output "subscription_arns"`

- **Objetivo**: Output para os ARNs das inscrições das filas SQS no tópico SNS.
- **Descrição**: Este output fornece uma lista dos ARNs das inscrições das filas SQS no tópico SNS, indicando quais filas estão inscritas para receber mensagens do tópico.

---

#### `output "queue_policy_ids"`

- **Objetivo**: Output para os IDs das políticas aplicadas às filas SQS.
- **Descrição**: Este output fornece uma lista dos IDs das políticas aplicadas às filas SQS para permitir o envio de mensagens do tópico SNS.

---

Estes outputs são úteis para recuperar informações importantes sobre os recursos criados no ambiente de mensageria, como o ARN do tópico SNS para referência em outras configurações, os IDs das filas SQS para monitoramento e gerenciamento, os ARNs das inscrições das filas no tópico SNS para verificar as configurações de entrega de mensagens e os IDs das políticas aplicadas às filas para controle de acesso e permissões.

Essas saídas são essenciais para integrar e utilizar os recursos criados neste ambiente de mensageria na AWS.

## Testando as Filas DLQ

Para testar o funcionamento das filas DLQ, vamos seguir os passos abaixo:

- **Processar a mensagem até falhar**:
  - Vamos produzir 2 ou mais mensagens para uma das filas, vamos utilizar como exemplo a fila **payment**.
  - No menu à esquerda, clique em **Enviar e receber mensagens** e depois em **Ver mensagens**.
  - Isso simula um consumidor da fila pegando a mensagem para processamento.
  - Uma das mensagens deve aparecer na tela. Clique em "Iniciar busca de mensagens" e depois em "Interromper a busca". Repita esse passo mais 3 vezes (um total de 4 vezes).
  - Após a quarta tentativa, a mensagem será redirecionada automaticamente para a DLQ **payment.dlq** associada à **payment**.

O procedimento acima simula o processamento com falhas no consumo da mensagem até que ela seja redirecionada para a fila DLQ após o número de tentativas definido pela variável maxReceiveCount.
