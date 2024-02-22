
provider "aws" {
  
  region = "us-east-1"
}

resource "aws_sqs_queue" "dlq" {
  
  count = length(var.sqs_queues)
  name = "${var.sqs_queues[count.index]}-dlq"
}

resource "aws_sqs_queue" "queue" {
  
  count = length(var.sqs_queues)
  name = var.sqs_queues[count.index]

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[count.index].arn
    maxReceiveCount     = 2
  })
}

resource "aws_sns_topic" "topic" {
  name = var.sns_topic
}

resource "aws_sns_topic_subscription" "queue_subscription" {
 
  count         = length(var.sqs_queues)
  topic_arn     = aws_sns_topic.topic.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.queue[count.index].arn
  filter_policy = jsonencode(var.filter_policies[var.sqs_queues[count.index]])
}

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


