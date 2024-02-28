
# Variável para definir a região da AWS onde os recursos serão criados
variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

# Variável para o nome do tópico SNS a ser criado
variable "sns_topic" {
  description = "Nome do tópico SNS"
  default     = "confirmed_sale"
}

# Variável para indicar se o tópico SNS deve ser FIFO (true) ou não (false)
variable "is_fifo_topic" {
  description = "Indica se o tópico SNS deve ser FIFO (true) ou não (false)"
  type        = bool
  default     = false
}

# Variável para os nomes das filas SQS a serem criadas
variable "sqs_queues" {
  description = "Nomes das filas SQS a serem criadas"
  default     = ["order", "payment", "shipment"]
}

# Variável para indicar se as filas SQS devem ser FIFO (true) ou não (false)
variable "is_fifo_queues" {
  description = "Indica se as filas SQS devem ser FIFO (true) ou não (false)"
  type        = list(bool)
  default     = [false, false, false]
}

# Variável para os filtros de política para cada assinatura nas filas SQS
variable "filter_policies" {
  description = "Filtros para cada assinatura"
  default = {
    "order"    = { eventType = ["order_placed"] },
    "payment"  = { eventType = ["payment_received"] },
    "shipment" = { eventType = ["shipment_dispatched"] }
  }
}


