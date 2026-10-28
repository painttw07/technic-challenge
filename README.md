# technic-challenge

Desafio técnico de automação de testes.

## Pré-requisitos

- Node.js 20+ (testado com Node 24)

```bash
npm install
npx playwright install chromium
```

## Testes

### 1. API testing: DummyJSON

Testes de API com Playwright contra a https://dummyjson.com. Os 4 cenários rodam em sequência:

1. Cadastra dois produtos.
2. Cria um carrinho com eles.
3. Consulta um carrinho existente e valida os itens.
4. Remove o carrinho.

```bash
npm run test:api
```

### 2. Web testing (UI): SauceDemo

Testes E2E com Playwright no https://www.saucedemo.com, estruturados no padrão Page Object Model (tests/03-web-testing/pages/). Não há esperas fixas: as asserções esperam a tela atualizar sozinhas. Os cenários são:

- Login com standard_user e redirecionamento para a página de produtos.
- Adição de 2 produtos ao carrinho e validação do contador.
- Checkout completo: carrinho, dados de entrega e confirmação "Thank you for your order!".

```bash
npm run test:web
```

### 3. Scripting: validação de e-mails

Script que lê os e-mails de tests/04-scripting/emails.txt, valida a sintaxe de cada um, confere se o domínio tem registro MX e gera o tests/04-scripting/validacao_emails.csv com as colunas `email,status,motivo`.

```bash
npm run validate:emails
```

## CI

O workflow .github/workflows/playwright.yml roda os testes de API e os testes web em etapas separadas a cada push ou pull request na `main`/`master`.
