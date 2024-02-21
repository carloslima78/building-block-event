
provider "aws" {
  region = "us-east-1"
}

variable "queue_names" {
  description = "Nomes das filas SQS a serem criadas"
  default     = ["order", "payment", "shipment"]
}

variable "filter_policies" {
  description = "Filtros para cada assinatura"
  default = {
    "order" = {
      eventType = ["order_placed"]
    },
    "payment" = {
      eventType = ["payment_received"]
    },
    "shipment" = {
      eventType = ["shipment_dispatched"]
    }
  }
}

variable "sns_topic_name" {
  description = "Nome do tópico SNS"
  default     = "confirmed_sale"
}

resource "aws_sqs_queue" "dlq" {
  count = length(var.queue_names)

  name = "${var.queue_names[count.index]}-dlq"
}

resource "aws_sqs_queue" "queue" {
  count = length(var.queue_names)

  name = var.queue_names[count.index]

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[count.index].arn
    maxReceiveCount     = 2
  })
}

resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "queue_subscription" {
  count         = length(var.queue_names)
  topic_arn     = aws_sns_topic.topic.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.queue[count.index].arn
  filter_policy = jsonencode(var.filter_policies[var.queue_names[count.index]])
}

resource "aws_sqs_queue_policy" "queue_policy" {
  count     = length(var.queue_names)
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


