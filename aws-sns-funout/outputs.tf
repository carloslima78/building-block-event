
# Output para o ARN do tópico SNS
output "topic_arn" {
  value = aws_sns_topic.topic.id
}

# Output para os IDs das filas SQS principais assinantes do tópico SNS
output "queue_ids" {
  value = [for q in aws_sqs_queue.queue : q.id]
}

# Output para os IDs das filas SQS de Dead Letter Queue (DLQ)
output "dlq_ids" {
  value = [for q in aws_sqs_queue.dlq : q.id]
}

# Output para os ARNs das inscrições das filas SQS no tópico SNS
output "subscription_arns" {
  value = [for sub in aws_sns_topic_subscription.queue_subscription : sub.arn]
}

# Output para os IDs das políticas aplicadas às filas SQS
output "queue_policy_ids" {
  value = [for policy in aws_sqs_queue_policy.queue_policy : policy.id]
}
