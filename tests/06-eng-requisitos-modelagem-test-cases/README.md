# US-042: Pagamento de cursos com PayPal

Os cenários estão em Gherkin no arquivo [`pagamento-paypal.feature`](pagamento-paypal.feature).

## Cenários

| # | Cenário | Tipo | Automatizar no CI? |
|---|---------|------|--------------------|
| 1 | Exibir a opção PayPal junto aos demais métodos | Caminho feliz | Sim |
| 2 | Concluir a compra com PayPal e ver "Pagamento Aprovado" | Caminho feliz | Sim, com o PayPal simulado |
| 3 | Liberar o acesso ao curso após o webhook | Webhook | Sim |
| 4 | Registrar os dados da transação | Webhook | Sim |
| 5 | Cancelamento ou recusa no PayPal | Cancelamento / exceção | Sim |
| 6 | PayPal indisponível | Exceção | Sim |
| 7 | Webhooks duplicados | Concorrência | Sim |
| 8 | Cliques repetidos em "Concluir Compra" | Concorrência | Sim |

## Priorização no CI/CD

Eu começaria pelos cenários de **webhook (3, 4 e 7)**, testados direto na API. É ali que estão o dinheiro e o acesso ao curso: um erro libera curso sem pagamento ou cobra sem liberar. Eles também são rápidos e estáveis, porque não dependem de navegador nem do PayPal: basta enviar o payload do webhook para a API.

Depois viriam os cenários de **checkout (1, 2, 5, 6 e 8)**, com as respostas do PayPal simuladas. Eles garantem que o aluno consegue comprar, não perde o carrinho quando algo dá errado e não é cobrado duas vezes. Simular o PayPal evita que o pipeline quebre por instabilidade do sandbox, que é externo. O caminho feliz contra o sandbox real eu rodaria à noite ou antes de cada release.

## Premissas

As mensagens e os status do pedido ("Pago", "aguardando confirmação") não estão definidos nos critérios de aceite, então usei sugestões que precisam ser confirmadas com o PO.
