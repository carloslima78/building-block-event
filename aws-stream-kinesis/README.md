# Building Block de Eventos Baseado em Kinesis

O Building Block para o Amazon Kinesis é projetado para facilitar a criação de streams Kinesis, permitindo uma configuração flexível e parametrizada.

O Amazon Kinesis é um serviço da AWS (Amazon Web Services) que permite o processamento de streams de dados em tempo real. 

Ele é usado para coletar, processar e analisar grandes volumes de dados em tempo real, sendo especialmente útil em aplicações que exigem baixa latência, como análises em tempo real, monitoramento de logs, detecção de fraudes e muito mais.

## Anatomia do Amazon Kinesis

O Amazon Kinesis é composto por três partes principais:

- **Streams**: Um stream é um fluxo de dados onde os dados são armazenados temporariamente. Ele é composto por shards, que são unidades de capacidade de processamento. Os dados são divididos em registros e colocados em shards, onde podem ser processados por consumidores.

- **Shards**: Um shard é uma unidade de capacidade de processamento no stream. Cada shard tem uma capacidade máxima de 1 MB por segundo para gravação de dados e 2 MB por segundo para leitura de dados. Mais shards significam maior capacidade de processamento.

- **Data**: 

## Recursos 

O Building Block para o Amazon Kinesis é projetado para facilitar a criação de streams Kinesis, permitindo uma configuração flexível e parametrizada. Abaixo estão os arquivos principais e suas funcionalidades:

### Arquivo `variables.tf` - Documentação

Este arquivo `variables.tf` é utilizado para definir as variáveis necessárias para a criação de recursos na AWS (Amazon Web Services) dentro de um ambiente de arquitetura de stream de dados.

Cada bloco de variável tem um propósito específico, detalhado a seguir:

#### `aws_region`

Define a região AWS onde os recursos Kinesis Streams serão criados.

kinesis_streams: 

Lista com os nomes dos Kinesis Streams a serem criados.

#### `shard_capacity`

Lista que define a capacidade em megabytes por shard para cada stream.

### Arquivo `main.tf` - Documentação

Este arquivo contém a configuração dos recursos na AWS (Amazon Web Services) para criar um ambiente de stream utilizando Kinesis.

---

#### `provider "aws"`

Configura o provedor AWS para definir a região onde os recursos serão criados.

#### `aws_kinesis_stream`

Cria os streams Kinesis com base nas variáveis definidas.

---

### Arquivo `output.tf` - Documentação

Este arquivo contém os outputs que fornecem informações sobre os recursos criados.

#### `kinesis_streams_info` 

Informações dos Kinesis Streams criados, como região, nome do stream, período de retenção e capacidade do shard.

#### `shards_per_stream`  

Quantidade de shards por stream.

## Testando o Buildint Block

Para testar o funcionamento criados:

Certifique-se de ter o Terraform instalado e configurado com suas credenciais AWS.
No diretório onde você tem os arquivos (main.tf, variables.tf, output.tf), execute os seguintes comandos:

terraform init
terraform plan
terraform apply

Isso criará os streams Kinesis de acordo com as configurações definidas.

### Produzindo uma Mensagem no Stream

Para produzir uma mensagem em um dos streams Kinesis:

Utilize o AWS CLI para enviar uma mensagem para o stream. Por exemplo, para enviar uma mensagem para o stream1:

aws kinesis put-record --stream-name stream1 --partition-key 123 --data "Sua mensagem aqui"

Substitua stream1 pelo nome do stream desejado e Sua mensagem aqui pela mensagem que deseja enviar.

### Consumindo a Mensagem do Stream

Para consumir a mensagem do stream:

1. Utilize o AWS CLI para obter os registros do stream:

aws kinesis get-records --shard-iterator $(aws kinesis get-shard-iterator --stream-name stream1 --shard-id shardId-000000000001 --shard-iterator-type TRIM_HORIZON --query 'ShardIterator' --output text)

Substitua stream1 pelo nome do stream desejado e shardId-000000000001 pelo ID do shard onde a mensagem foi gravada.

2. O comando retornará uma resposta codificada em base64. Decodifique a resposta usando um site como (base64decode.org) ou no terminal usando o comando base64:

echo "Sua resposta codificada em base64" | base64 --decode

Substitua Sua resposta codificada em base64 pela resposta que você recebeu do comando anterior.
