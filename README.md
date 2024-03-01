# Building Block Event

Um building block padronizado e parametrizado para geração de eventos de mensageria e streaming é uma estrutura modular que fornece uma base consistente e flexível para criar sistemas de mensageria e streaming de dados. Ele é projetado para ser configurável com parâmetros específicos, permitindo a geração e encaminhamento de eventos entre diferentes partes de um sistema. 

Esse tipo de bloco facilita a implementação ágil e escalável de arquiteturas de eventos, possibilitando a captura, processamento e distribuição de dados de maneira eficiente e confiável. Esses building blocks são essenciais para criar pipelines de eventos e análise em tempo real, suportando uma variedade de casos de uso, como notificações, processamento de dados em tempo real, integração entre sistemas e análise de dados em larga escala.

## O que é um Buidking Block

Um Building Block é um componente fundamental ou unidade básica que pode ser combinado com outros para criar estruturas mais complexas. Na área de negócios e gestão, os Building Blocks são elementos essenciais de um modelo de negócios ou estratégia, como segmentos de clientes, proposta de valor, canais de distribuição e recursos-chave. 

Eles formam a base sobre a qual uma organização constrói e adapta suas operações para alcançar seus objetivos.

## Matriz de Decisão

A escolha entre utilizar Amazon SNS + SQS para mensageria e Amazon Kinesis para streaming de dados depende de vários fatores, incluindo o caso de uso específico, a escala, a latência aceitável, o processamento de mensagens, entre outros. 

Abaixo, apresento uma matriz de decisão que destaca as principais diferenças e considerações para ajudar na escolha entre essas duas soluções da AWS:

| Critério                      | SNS + SQS                                           | Kinesis                                         |
|-------------------------------|-----------------------------------------------------|-------------------------------------------------|
| **Tipo de Dados**             | Mensagens                                           | Streams de dados                                |
| **Casos de Uso**              | Desacoplamento de aplicações, notificações, sistemas de filas | Análise em tempo real, monitoramento de logs, telemetria |
| **Modelo de Processamento**   | Consumo de mensagens sem ordem garantida (SQS padrão) ou com ordem (SQS FIFO) | Processamento sequencial de dados em ordem     |
| **Escala**                    | Milhões de mensagens por segundo por tópico/fila    | Até terabytes por hora por stream               |
| **Latência**                  | Milissegundos a segundos                            | Segundos (pode ser reduzido com otimizações)    |
| **Durabilidade**              | Mensagens armazenadas até serem processadas (configurável) | Dados armazenados de 1 a 365 dias (configurável)|
| **Retenção de Mensagens**     | Até 14 dias para SQS                                | Configurável, até 365 dias para Kinesis         |
| **Consumidores**              | Múltiplos consumidores podem processar as mesmas mensagens de forma independente | Múltiplos aplicativos podem consumir o mesmo stream simultaneamente, mas compartilham a mesma sequência de dados |
| **Custo**                     | Baseado no número de solicitações (publicações, entregas, polls) | Baseado no throughput de dados (shards) e no armazenamento de dados |
| **Integrações**               | Integrações diretas com outros serviços da AWS via SNS | Integrações através de AWS Lambda, AWS Data Firehose, etc. |
| **Flexibilidade de Consumo**  | Consumidores processam mensagens de forma assíncrona quando estão prontos | Consumidores devem estar sempre ativos e processar dados em tempo real ou próximo a isso |

### Decisão

- **SNS + SQS:** Ideal para casos de uso que requerem alta confiabilidade e a capacidade de processar ou armazenar mensagens até que os consumidores estejam prontos para processá-las. Excelente para aplicações que necessitam de desacoplamento, escalabilidade e a possibilidade de processar as mesmas mensagens por múltiplos consumidores de forma independente.

- **Kinesis:** Melhor escolha para casos de uso que envolvem análise de grandes volumes de dados em tempo real, como monitoramento de logs, telemetria e processamento de eventos em tempo real. Kinesis fornece a capacidade de processar e analisar dados em alta velocidade com consumidores que processam streams de dados sequenciais.

A escolha entre essas soluções deve ser baseada nas necessidades específicas de processamento, latência, ordem das mensagens, custo e integrações do sistema. Avalie os requisitos do seu projeto em relação a esses critérios para tomar a decisão mais informada.