# language: pt

Funcionalidade: Pagamento de cursos com PayPal
  Como um aluno interessado em adquirir cursos na plataforma de ensino online
  Quero realizar o pagamento das minhas compras utilizando minha conta PayPal
  Para que eu tenha uma opção de pagamento rápida, segura e sem a necessidade de digitar os dados do meu cartão diretamente no site

Contexto:
  Dado que o aluno "aluno@teste.com" está autenticado na plataforma
  E possui no carrinho o curso "Automação de Testes com Playwright" no valor de R$ 199,90
  E está na tela de Checkout

  # ---------------------------------------------------------------------------
  # Happy Path
  # ---------------------------------------------------------------------------

  Cenário: Exibir a opção PayPal junto aos demais métodos de pagamento
    Então devem ser exibidos os métodos de pagamento:
      | método            |
      | Cartão de Crédito |
      | Pix               |
      | PayPal            |

  Cenário: Concluir a compra com PayPal e ver o pagamento aprovado
    Dado que o aluno selecionou o método de pagamento "PayPal"
    Quando clicar em "Concluir Compra"
    Então o ambiente seguro do PayPal deve ser aberto em uma nova janela/pop-up
    Quando o aluno se autenticar no PayPal e confirmar o pagamento
    Então o aluno deve ser redirecionado para a página de sucesso da plataforma
    E deve ser exibido o status "Pagamento Aprovado"

  # ---------------------------------------------------------------------------
  # Notificação assíncrona via Webhook
  # ---------------------------------------------------------------------------

  Cenário: Liberar o acesso ao curso imediatamente após o webhook de confirmação
    Dado que existe o pedido "PED-1001" aguardando confirmação do pagamento
    Quando a plataforma receber do PayPal o webhook de pagamento confirmado para o pedido "PED-1001"
    Então o pedido "PED-1001" deve ficar com o status "Pago"
    E o acesso do aluno ao curso deve ser liberado imediatamente

  Cenário: Registrar corretamente os dados da transação
    Dado que o aluno concluiu o pagamento do pedido "PED-1001" no PayPal
    Quando a plataforma receber o webhook de pagamento confirmado com o ID de transação "8AB12345CD678901E"
    Então a transação deve ser registrada com os dados:
      | campo                  | valor                   |
      | ID do pedido           | PED-1001                |
      | ID da transação PayPal | 8AB12345CD678901E       |
      | valor                  | 199.90                  |
      | moeda                  | BRL                     |
      | data/hora              | data/hora do pagamento  |

  # ---------------------------------------------------------------------------
  # Cancelamento e fluxos de exceção/falha
  # ---------------------------------------------------------------------------

  Esquema do Cenário: Retornar ao Checkout mantendo o carrinho quando o pagamento não é concluído
    Dado que o aluno selecionou o método de pagamento "PayPal"
    E clicou em "Concluir Compra"
    Quando <acao_no_paypal>
    Então o aluno deve ser redirecionado para a tela de Checkout
    E deve ser exibida a mensagem "<mensagem>"
    E o curso deve continuar no carrinho
    E o acesso ao curso não deve ser liberado

    Exemplos:
      | acao_no_paypal                            | mensagem                                                                               |
      | o aluno cancelar o pagamento no PayPal    | Pagamento cancelado. Seus itens continuam no carrinho.                                 |
      | o PayPal recusar a transação              | Não foi possível concluir o pagamento com PayPal. Tente novamente ou use outro método. |

  Cenário: Indisponibilidade do PayPal ao iniciar o pagamento
    Dado que o aluno selecionou o método de pagamento "PayPal"
    E o PayPal está indisponível
    Quando clicar em "Concluir Compra"
    Então deve ser exibida a mensagem "O PayPal está indisponível no momento. Tente novamente ou use outro método."
    E o curso deve continuar no carrinho

  # ---------------------------------------------------------------------------
  # Concorrência
  # ---------------------------------------------------------------------------

  Cenário: Processar webhooks duplicados apenas uma vez
    Dado que existe o pedido "PED-1001" aguardando confirmação do pagamento
    Quando a plataforma receber ao mesmo tempo 3 webhooks iguais de pagamento confirmado para o pedido "PED-1001"
    Então deve existir apenas 1 registro de transação para o pedido "PED-1001"
    E o aluno deve receber apenas 1 e-mail de confirmação

  Cenário: Evitar cobrança duplicada com cliques repetidos em "Concluir Compra"
    Dado que o aluno selecionou o método de pagamento "PayPal"
    Quando clicar 2 vezes seguidas em "Concluir Compra"
    Então apenas 1 janela do PayPal deve ser aberta
    E o aluno deve ser cobrado apenas uma vez
