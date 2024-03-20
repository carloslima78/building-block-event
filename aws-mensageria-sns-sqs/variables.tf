
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

# Variável para definir a quantidade máxima de recebimentos de mensagens com falha
variable "max_receive_count" {
  description = "Define a quantidade máxima de recebimentos de mensagens com falha"
  type        = number
  default     = 3
}

# Variável para indicar se as filas SQS devem ser FIFO (true) ou não (false)
variable "is_fifo_queues" {
  description = "Indica se as filas SQS devem ser FIFO (true) ou não (false)"
  type        = list(bool)
  default     = [false, false, false]
}

# Variável para indicar quais filas terão filtro (true) ou não (false)
variable "use_filter" {
  description = "Indica se a fila deve ter filtro (true) ou não (false)"
  type        = list(bool)
  default     = [true, true, false]
}

# Variável para os filtros de política para cada assinatura nas filas SQS
variable "filter_policies" {
  description = "Filtros para cada fila SQS"
  type        = map(any)
  default = {
    "order"    = { eventType = ["order_placed"] },
    "payment"  = { eventType = ["payment_received"] },
    "shipment" = null
  }
}

# Variável para os nomes dos tópicos SNS de retorno (opcional)
variable "return_sns_topics" {
  description = "Nomes dos tópicos SNS de retorno (opcional)"
  type        = list(string)
  default     = []
}

# Variável para indicar se os tópicos SNS de retorno devem ser FIFO (true) ou não (false)
variable "is_fifo_return_topics" {
  description = "Indica se os tópicos SNS de retorno devem ser FIFO (true) ou não (false)"
  type        = list(bool)
  default     = [false]
}

# Variável para os nomes das filas SQS de retorno (opcional)
variable "return_sqs_queues" {
  description = "Nomes das filas SQS de retorno (opcional)"
  type        = list(string)
  default     = []
}

# Variável para indicar se as filas SQS de retorno devem ser FIFO (true) ou não (false)
variable "is_fifo_return_queues" {
  description = "Indica se as filas SQS de retorno devem ser FIFO (true) ou não (false)"
  type        = list(bool)
  default     = [false]
}