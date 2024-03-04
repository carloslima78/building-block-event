# Output para exibir informações dos Kinesis Streams criados
output "kinesis_streams_info" {
  description = "Informações dos Kinesis Streams criados"

  # O valor deste output é um mapa
  value = {
    for idx, name in var.kinesis_streams :        # Itera sobre a lista de streams
    name => {                                     # Cria um objeto para cada stream
      region          = var.aws_region            # Região AWS para todos os streams
      stream_name     = name                      # Nome do stream
      retention_hours = var.retention_period[idx] # Período de retenção do stream
      shard_capacity  = var.shard_capacity[idx]   # Capacidade de shard do stream
    }
  }
}

# Output para exibir a quantidade de shards por stream
output "shards_per_stream" {
  description = "Quantidade de shards por stream"

  # O valor deste output é um mapa
  value = {
    for idx, name in var.kinesis_streams : # Itera sobre a lista de streams
    name => var.shard_capacity[idx]        # Associa o nome do stream à capacidade de shard
  }
}
