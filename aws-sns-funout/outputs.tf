
# Output para o ARN do tópico SNS
output "topic_arn" {
  value = aws_sns_topic.topic.arn
}

# Output para os IDs das filas SQS principais assinantes do tópico SNS
output "queue_ids" {
  value = aws_sqs_queue.queue[*].id
}

# Output para os IDs das filas SQS de Dead Letter Queue (DLQ)
output "dlq_ids" {
  value = aws_sqs_queue.dlq[*].id
}

# Output para os ARNs das inscrições das filas SQS no tópico SNS
output "subscription_arns" {
  value = aws_sns_topic_subscription.queue_subscription[*].arn
}

# Output para os IDs das políticas aplicadas às filas SQS
output "queue_policy_ids" {
  value = aws_sqs_queue_policy.queue_policy[*].id
}

# Output para os ARNs dos tópicos SNS de retorno
output "return_topic_arns" {
  value = aws_sns_topic.return_topics[*].arn
}

# Output para os IDs das filas SQS de retorno
output "return_queue_ids" {
  value = aws_sqs_queue.return_queues[*].id
}

# Output para os ARNs das inscrições das filas SQS de retorno nos tópicos SNS de retorno
output "return_subscription_arns" {
  value = aws_sns_topic_subscription.return_subscriptions[*].arn
}

# Output para os IDs das políticas aplicadas às filas SQS de retorno
output "return_queue_policy_ids" {
  value = aws_sqs_queue_policy.return_queue_policy[*].id
}
