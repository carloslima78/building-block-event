
variable "sqs_queues" {
  
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

variable "sns_topic" {
  
  description = "Nome do tópico SNS"
  default     = "confirmed_sale"
}
