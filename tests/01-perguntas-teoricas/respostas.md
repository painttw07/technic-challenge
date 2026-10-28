# Parte 1: Questões Teóricas

## 1. Qual é o principal objetivo da análise de risco no processo de teste?

Na prática, é decidir onde vale a pena gastar o tempo de teste. Nunca dá para testar tudo, então a análise de risco me ajuda a olhar para cada funcionalidade e pensar em duas coisas: qual a chance de dar problema e qual o estrago se der. O que tem as duas coisas altas recebe mais atenção, mais cenários e entra primeiro na automação. Um exemplo: num e-commerce, o checkout e o pagamento são testados a fundo em toda release, enquanto uma página institucional recebe uma validação bem mais leve. Além de priorizar, a análise de risco também ajuda na hora de liberar uma versão, porque deixa claro para o time e para o negócio quais riscos estão sendo aceitos.

## 2. O que é um teste baseado em requisitos? Cite exemplos.

É quando os casos de teste nascem dos requisitos: história de usuário, critério de aceite, regra de negócio. Acredito que a ideia seja garantir que o sistema faz o que deveria, e cada teste fica ligado ao requisito que ele valida.

Exemplos:

- Critério de aceite "o ícone do carrinho deve mostrar a quantidade de itens": adiciono 2 produtos e confiro se aparece "2". Fiz exatamente isso nos testes web do SauceDemo deste repo.
- Regra "frete grátis acima de R$ 200": testo com R$ 199,99, R$ 200,00 e R$ 200,01, que é onde normalmente aparecem os bugs.
- Os cenários em Gherkin que escrevi para o pagamento com PayPal também acabam sendo baseados em requisitos.

## 3. O que é um teste unitário e quem os realiza? Cite exemplos.

É o teste da menor parte do código, como uma função ou um método, isolada do resto. São testes muito rápidos, e são a base da pirâmide. Quem escreve normalmente são os devs, junto com o código. Como QA, eu costumo participar revisando a cobertura no PR e sugerindo cenários de borda que ficaram de fora.

## 4. O que é um teste de Integração e quem os realiza? Cite exemplos.

É o teste que verifica se as partes do sistema conversam direito entre si. Alguns bugs que já peguei estavam justamente aí: campo que um serviço manda e o outro não lê, timeout, problema de autenticação entre serviços. Cada parte funcionava sozinha, mas juntas não. A integração dentro de um mesmo serviço geralmente fica com os devs.

## 5. Você precisa realizar testes de Performance em uma aplicação web que calcula o tempo das rotas de entrega para um serviço de entregas por motoboys que realiza 20 milhões de entregas por dia. Quais os conceitos de Testes de Performance você consideraria para esta situação? E quais tipos de Testes de Performance você realizaria nesta situação?

Antes de qualquer coisa, eu faria a conta do volume. 20 milhões de entregas por dia dão uma média de uns 230 cálculos por segundo, mas ninguém pede comida de forma uniforme ao longo do dia. No almoço e no jantar o volume pode ser 3 a 5 vezes maior. E uma entrega pode gerar vários cálculos. Então eu buscaria os números reais em logs para montar um perfil de carga, em vez de testar só a média. Conceitos que eu levaria em conta: Tempo de resposta por percentil e não só a média, throughput (quantas requisições por segundo o sistema aguenta), taxa de erro sob carga e dependências externas.

Tipos de teste que eu faria:

- Carga: simular o pico esperado e ver se os critérios são atendidos.
- Estresse: aumentar além do pico até quebrar, para saber o limite e como o sistema se recupera.
- Volume: muito histórico de entregas no banco, para validar consultas e índices.
- E um teste curto de performance no CI, para pegar regressão de tempo de resposta logo no PR.

## 6. O que é CI e CD (Continuous Integration e Continuous Delivery/Deployment)? Cite exemplos práticos aplicados ao QA.

- CI (Integração Contínua): o código é integrado na branch principal com frequência, e cada integração roda o build e os testes automaticamente. Assim o problema aparece logo, perto de quem mexeu.
- Continuous Delivery: tudo que passa pela pipeline fica pronto para ir para produção, mas o deploy final ainda depende de uma aprovação.
- Continuous Deployment: o deploy em produção acontece automaticamente quando a pipeline passa, sem aprovação manual.

Como isso aparece no meu dia a dia de QA:

- Testes de API e E2E rodando em todo PR. Neste repositório, o GitHub Actions roda os testes de API e web em etapas separadas.
- Quality gate: o merge fica bloqueado se algum teste falhar, se a cobertura cair ou se a análise de segurança apontar algo crítico.
- Smoke test automático depois do deploy em homologação e produção.

## 7. Qual tipo de teste foca no comportamento interno do software?

O teste de caixa-branca (estrutural). Ele parte do conhecimento do código e tenta cobrir caminhos, condições e decisões. Testes unitários com análise de cobertura de código são o exemplo mais comum.

## 8. Qual tipo de teste foca no comportamento externo do software?

O teste de caixa-preta (funcional). Ele olha para entradas e saídas a partir dos requisitos, sem se preocupar com como o código foi feito. É onde entram técnicas como valor limite e tabela de decisão. Os testes E2E e de API que faço no dia a dia são, na maioria, caixa-preta.

## 9. Cite a importância dos testes Exploratórios.

Para mim, o exploratório é onde aparecem os bugs que ninguém imaginou. O teste roteirizado e a automação confirmam o que a gente já sabe que precisa funcionar, o exploratório descobre o que ninguém pensou em escrever.

Alguns motivos para eu sempre reservar tempo para ele:

- Pega problemas de usabilidade e combinações inesperadas que nenhum caso de teste previa.
- Funciona muito bem em funcionalidade nova, quando os requisitos ainda estão mudando.
- Usa o conhecimento que a gente vai acumulando do produto: com o tempo, você sabe onde o sistema costuma quebrar.
- O que eu encontro vira caso de teste e, quando faz sentido, automação.

## 10. Quais são os benefícios de termos uma automação de testes funcionais?

Do meu ponto de vista, são:

- A regressão que levaria dias rodando manualmente roda em minutos, a cada PR.
- O bug aparece logo depois de ser introduzido, quando é mais fácil e barato corrigir.
- O teste é executado sempre do mesmo jeito, sem cansaço nem passo esquecido.
- O time ganha confiança para refatorar e liberar com mais frequência.
- Dá para cobrir vários navegadores e massas de dados sem multiplicar o esforço.
- E o principal para mim: libera o QA do trabalho repetitivo para focar em exploratório, análise de risco e refinamento.

## 11. Em qual etapa do projeto o QA deve ser envolvido?

Desde o começo. Quanto antes o QA participa, melhor, ou seja, uma dúvida levantada no refinamento custa uma conversa, e o mesmo problema encontrado em produção pode custar um incidente. Nos refinamentos, eu gosto de ajudar a escrever critérios de aceite que dão para testar e aponto riscos e cenários que ninguém pensou. Durante o desenvolvimento, vou preparando os cenários e a automação em paralelo (shift-left-testing) e converso com os devs. Depois do deploy, acompanho logs, métricas e o feedback dos usuários, e isso volta para a suíte de testes. Acredito que, o QA que só entra no fim acaba virando gargalo.

## 12. Como manter um trabalho ágil como um todo?

O que vi funcionar nos times em que trabalhei:

- Histórias pequenas e bem fatiadas, que dá para desenvolver, testar e entregar dentro da sprint.
- Teste fazendo parte da DOD, e não uma fase depois do "pronto".
- Pouco trabalho em andamento ao mesmo tempo. Muita coisa aberta quase sempre termina em tudo chegando junto no último dia.
- Conversa direta entre PO, dev e QA, em vez de ficar passando documento de um para o outro.
- Retrospectivas que geram ações de verdade, e alguém acompanhando se elas foram feitas.
- Impedimentos visíveis para todo mundo.

## 13. Na sua visão, a Qualidade do Software é uma responsabilidade apenas do QA? Justifique sua resposta.

Não. A qualidade é construída pelo time inteiro, em todas as etapas. O PO precisa trazer requisitos claros, os devs escrevem código limpo e testes unitários e fazem code review, o design cuida da usabilidade e da acessibilidade, e o pessoal de infra garante ambientes estáveis e monitoramento. O papel do QA é puxar esse assunto: definir a estratégia de testes, levantar riscos, automatizar, explorar e mostrar para o time como está a qualidade. Quando a qualidade fica só nas nossas costas de QA, viramos um portão no fim do processo e os bugs aparecem tarde, quando é mais caro corrigir. Já passei por times assim, e a diferença quando o time inteiro assume a qualidade é muito grande.

## 14. Indique uma ou mais formas de executar testes não funcionais, e explique a importância dos mesmos.

Algumas formas que já usei ou que considero essenciais:

- Acessibilidade: axe-core integrado aos testes E2E, Lighthouse e testes com leitor de tela.
- Compatibilidade: rodar a mesma suíte em vários navegadores e dispositivos (projetos do Playwright).
- Usabilidade: testes com usuários reais

## 15. Indique maneiras de dar visibilidade das tarefas do QA pro time como um todo.

Meu ponto de vista:

- Tarefas de teste no quadro da sprint, estimadas como qualquer outra tarefa.
- Aviso no Slack ou no Teams quando algo quebra.
- Dashboard com bugs abertos por severidade, resultado das execuções e testes instáveis.
- Falar de qualidade nas cerimônias: status na daily, demonstrar automações na review, trazer pontos de melhoria na retro.
- Documentação acessível: estratégia de testes e cenários num lugar que todo mundo consulta (wiki ou o próprio repositório, como os READMEs deste projeto).

## 16. De um modo geral, explique as vantagens dos testes manuais e dos automatizados, dê exemplos de aplicação de cada um e seus devidos benefícios.

Testes manuais:

- Vantagens: têm o olhar humano, que percebe quando algo está estranho, confuso ou feio. São flexíveis, custam pouco para começar e fazem sentido quando a funcionalidade ainda está mudando muito.
- Onde eu uso: exploratório em funcionalidade nova, validação de usabilidade e layout, testes de aceitação com o usuário, e cenários raros que dariam muito trabalho para automatizar, como o pagamento em duas abas da Parte 6.

Testes automatizados:

- Vantagens: são rápidos, repetíveis, rodam a cada PR e escalam para vários navegadores e massas de dados sem custo extra por execução.
- Onde eu uso: regressão de fluxos críticos (como login, carrinho e checkout da Parte 3), testes de API (Parte 2), smoke depois do deploy, performance e validações em massa (como o script de e-mails da Parte 4).

Os dois se completam. Eu automatizo o que é estável, repetitivo e crítico, e deixo o tempo de teste manual para o que precisa de julgamento.

## 17. Na sua visão, o que a IA pode colaborar para os testes de software? Cite exemplos que possam ajudar no dia a dia.

A IA já faz parte do meu dia a dia e me ajuda bastante, mas tudo o que ela gera eu reviso. Ela acelera, mas quem decide o que testar continua sendo eu. Alguns usos práticos:

- Gerar uma primeira versão de cenários e casos de teste a partir de uma história, que depois eu ajusto e complemento.
- Acelerar a automação: estrutura de testes no Playwright, page objects, scripts de apoio.
- Gerar massa de dados realista (CPF válido, endereços, nomes).
- Revisar requisitos e apontar ambiguidades antes do desenvolvimento.
- Resumir logs grandes e ajudar a entender por que um teste falhou.
- Escrever relatórios de bug mais claros.
- Ferramentas de teste visual e de "self-healing" de seletores, que reduzem a manutenção da automação.

E também tem o outro lado: cada vez mais a gente precisa testar sistemas que usam IA, como chatbots (um dos projetos que trabalhei). Isso traz desafios novos, como respostas inconsistentes, informações inventadas e tentativas de manipular o modelo com prompts.

## 18. Cite exemplos da importância da rastreabilidade nos testes.

Conseguir ligar requisito, caso de teste, execução e bug. Onde eu vejo isso fazer diferença:

- Mudança de regra: quando uma regra de negócio muda, eu sei exatamente quais testes revisar e rodar de novo.
- Priorização de bugs: um bug ligado a um requisito crítico, como pagamento, sobe de prioridade.
- Decisão de release: fica fácil responder "o que desta versão está validado e o que ainda tem bug aberto?".
- Bug em produção: ajuda a entender qual requisito foi afetado, se existia teste e por que ele não pegou o problema.

## 19. Na sua visão, quando os testes são o suficiente?

Teste nunca é infinito, então "suficiente" para mim é uma decisão baseada em risco, combinada com o time e com o negócio. Eu considero suficiente quando:

- os critérios de saída combinados foram atingidos: critérios de aceite validados, fluxos críticos cobertos, nenhum bug crítico ou alto em aberto e regressão passando;
- os riscos que sobraram são conhecidos, pequenos e o negócio aceitou conscientemente;
- continuar testando já não está trazendo bugs novos relevantes.

## 20. Vamos imaginar 2 cenários que não são ideais: 1 - O QA está atuando sozinho na squad, mas os DEVs entregam as tarefas com certa rapidez (embora seja bastante coisa para apenas uma pessoa). 2 - A equipe de QA é suficiente porém os DEVs liberam as tarefas no final da sprint. Na sua visão, qual dos 2 cenários acima é o pior e por quê? Como você atuaria para resolver?

Para mim, o cenário 2 é o pior (equipe de QA suficiente, mas os devs liberando tudo no fim da sprint). Já vivi os dois. O cenário 1 é puxado, mas o trabalho flui, e dá para melhorar com priorização e automação. O cenário 2 é um problema de processo, e colocar mais QA não resolve. A sprint vira uma mini cascata: o QA fica ocioso no começo e afogado no fim, os bugs aparecem quando não dá mais tempo de corrigir, e as histórias vão para a próxima sprint ou são entregues sem o teste adequado.

Como eu atuaria no cenário 2:

- Levar o problema para a retro com dados. Por exemplo: "nas últimas 3 sprints, 80% das histórias chegaram para teste nos últimos 2 dias".
- Propor histórias menores, que vão ficando prontas ao longo da sprint.
- Limitar o trabalho em andamento: terminar antes de começar outra coisa.
- Entrar desde o refinamento e deixar os cenários de teste prontos antes do código.
- Testar em paralelo ao desenvolvimento, com entregas parciais, feature flags e pareamento com os devs.
- Usar o início da sprint, que fica mais tranquilo, para avançar na automação.

## 21. Diferencie teste estático e dinâmico.

O teste estático é feito sem executar o software. Analisa requisitos, documentação e código. A vantagem é que pega problemas bem cedo, como ambiguidade num requisito ou falha de segurança no código, antes mesmo de existir algo para rodar. Já o teste dinâmico é feito executando o software e observando o comportamento dele. Ele encontra falhas reais em funcionamento: resultado errado, erro, lentidão.

## 22. Diferencie teste alfa e beta.

O teste alfa acontece dentro da empresa, num ambiente controlado feito por pessoas internas. O produto está quase pronto, e o objetivo é pegar bugs e problemas de usabilidade antes de expor ao público. O teste beta acontece depois do alfa, com usuários reais, no ambiente deles. O objetivo é validar o produto em condições reais e coletar feedback antes do lançamento oficial.

## 23. O que é Splunk? Ele pode ser usado por QAs? Se sim, cite exemplos práticos.

O Splunk é uma ferramenta que centraliza e indexa os logs das aplicações e servidores, e permite fazer buscas, montar dashboards e criar alertas em cima deles. É muito útil para o QA para investigar um bug e achar erros silenciosos.

## 24. Cite exemplos de como a AWS (ou serviços de Nuvem) pode ser usada no trabalho do QA.

Como tenho pouco conhecimento sobre, acredito que subir ambientes de teste temporários por PR e destruir depois, pagando só pelo tempo de uso e rodar a suíte E2E em paralelo em vários containers, para reduzir o tempo de regressão.

## 25. Você precisa executar um script de Performance via linha de comando para um projeto. Escreva um exemplo de linha de comando para executar um script performático (ex: JMeter em modo não-GUI ou k6).

-

## 26. Você é um QA especialista em Testes de Performance. Você tem 2 clientes principais: Uma grande indústria de carros e um programa de TV com vários patrocinadores. Nesse cenário, qual dos dois clientes necessita mais de um teste performático e por quê?

Acredito que o programa de TV com vários patrocinadores: O motivo principal é o tipo de acesso. Num programa de TV, o tráfego vem em picos enormes e repentinos, uma votação ao vivo, um QR code na tela, uma promoção de patrocinador anunciada pelo apresentador. Milhões de pessoas entram no mesmo minuto, e esse é exatamente o cenário que testes de pico e estresse existem para cobrir. A indústria de carros também precisa de testes de performance, mas o acesso aos sistemas dela costuma ser mais estável e previsível. A exceção seria algo como uma pré-venda online de um lançamento muito divulgado, que se parece com o cenário da TV.

## 27. Você é Especialista em Automação de Testes, porém sua empresa tem uma resistência muito grande para aderir à automação (mesmo necessitando). Que estratégia você usaria para convencer seus gestores e a empresa como um todo a usarem a automação de testes?

Acho que a primeira coisa seria entender de onde vem a resistência ("É custo?"). Em seguida, levar números, e não opinião (medir quanto tempo a regressão manual leva a cada release, quantos bugs estão chegando em produção e quanto isso custa). Também, começar pequeno(escolher um fluxo crítico e repetitivo, como login e checkout, automatizar em poucas semanas) e mostrar o valor quando ele aparecer(o primeiro bug que a automação pegar antes de chegar ao cliente).

## 28. O que é teste de confiabilidade?

É o teste que verifica se o sistema funciona de forma consistente, sem falhar, por um período de tempo e em determinadas condições Um exemplo seria deixar o sistema sob carga por 24 horas para ver se ele degrada ou vaza memória.

## 29. O que é teste de portabilidade?

É o teste que verifica se o software funciona corretamente em ambientes diferentes, e se é fácil de instalar, atualizar ou migrar entre eles. Ambientes diferentes aqui são outros sistemas operacionais e navegadores. Como exemplo: rodar a mesma suíte no Chrome, Firefox e Safari ou até testar o app em várias versões de Android e iOS.

## 30. O que é teste de segurança?

É o teste que verifica se o sistema protege os dados e as funcionalidades contra acessos e usos indevidos, encontrando as vulnerabilidades antes que alguém mal-intencionado encontre.

Exemplos do que eu verifico ou acompanho:

- Controle de acesso: um usuário não pode ver o pedido de outro só trocando o ID na URL. É um teste simples, e já vi esse bug mais de uma vez.
- Autenticação e sessão: bloqueio após várias tentativas de senha, token expirando, logout realmente encerrando a sessão.
