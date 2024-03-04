# Definição do provider AWS
provider "aws" {
  # Define a região AWS para os recursos
  region = var.aws_region
}

# Criar os streams do Kinesis
resource "aws_kinesis_stream" "kinesis_streams" {
  # O número de iterações será igual ao comprimento da lista de nomes de streams
  count = length(var.kinesis_streams)

  # Nome do stream obtido da lista de nomes de streams, utilizando o índice
  name = var.kinesis_streams[count.index]

  # Número de shards para cada stream, obtido da lista de capacidades de shard
  shard_count = length(var.shard_capacity) > count.index ? var.shard_capacity[count.index] : null

  # Período de retenção para cada stream, obtido da lista de períodos de retenção
  retention_period = length(var.retention_period) > count.index ? var.retention_period[count.index] : null
}
