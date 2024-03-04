# Variável para definir a região da AWS onde os recursos serão criados
variable "aws_region" {
  description = "AWS Region onde os recursos Kinesis Streams serão criados."
  type        = string
  default     = "us-east-1"
}

# Variável para os nomes dos Kinesis Streams a serem criados
variable "kinesis_streams" {
  description = "Lista com os nomes dos Kinesis Streams a serem criados."
  type        = list(string)
  default     = ["stream1", "stream2"]
}

# Variável para definir o período de retenção em horas para cada stream
variable "retention_period" {
  description = "Mapa que define período de retenção em horas para cada stream."
  type        = list(number)
  default     = [24, 48]
}

# Variável para definir a capacidade em megabytes por shard para cada stream
variable "shard_capacity" {
  description = "Lista que define a capacidade em megabytes por shard para cada stream."
  type        = list(number)
  default     = [1, 2]
}
