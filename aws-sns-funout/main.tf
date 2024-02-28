
# Provider AWS para configurar a região onde os recursos serão criados
provider "aws" {
  region = var.aws_region
}

# Recurso para criar o tópico SNS
resource "aws_sns_topic" "topic" {
  name       = var.is_fifo_topic ? "${var.sns_topic}.fifo" : var.sns_topic
  fifo_topic = var.is_fifo_topic
}

# Recurso para criar as filas SQS principais assinatnes do tópico SNS
resource "aws_sqs_queue" "queue" {
  count      = length(var.sqs_queues)
  name       = var.is_fifo_queues[count.index] ? "${var.sqs_queues[count.index]}.fifo" : var.sqs_queues[count.index]
  fifo_queue = var.is_fifo_queues[count.index]

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[count.index].arn
    maxReceiveCount     = 2
  })
}

# Recurso para criar as filas SQS de Dead Letter Queue (DLQ) para cada fila assinante
resource "aws_sqs_queue" "dlq" {
  count      = length(var.sqs_queues)
  name       = var.is_fifo_queues[count.index] ? "${var.sqs_queues[count.index]}-dlq.fifo" : "${var.sqs_queues[count.index]}-dlq"
  fifo_queue = var.is_fifo_queues[count.index]
}

# Recurso para criar as inscrições das filas SQS no tópico SNS
resource "aws_sns_topic_subscription" "queue_subscription" {
  count         = length(var.sqs_queues)
  topic_arn     = aws_sns_topic.topic.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.queue[count.index].arn
  filter_policy = jsonencode(var.filter_policies[var.sqs_queues[count.index]])
}

# Recurso para aplicar políticas às filas SQS para permitir envio de mensagens do tópico SNS
resource "aws_sqs_queue_policy" "queue_policy" {
  count     = length(var.sqs_queues)
  queue_url = aws_sqs_queue.queue[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSNSPublishing"
        Effect    = "Allow"
        Principal = { Service = "sns.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.queue[count.index].arn
        Condition = {
          ArnEquals = { "aws:SourceArn" = aws_sns_topic.topic.arn }
        }
      }
    ]
  })
}
