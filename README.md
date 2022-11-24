# Sistema de Pagamento e Antifraude
Projeto de app e api para pacotes de seguros: Campus Code - TreinaDev Delas! - Treinadev turma 9.

Confira abaixo as outras aplicações que conversam com o nosso sistema para criar um ecossistema de seguros:

##### [Sistema de Seguradoras](https://github.com/TreinaDev/insurance-app)

##### [Sistema Comparador de Seguros](https://github.com/TreinaDev/insurance-comparator-app)

## Sumário

  * [Configurações](#configurações)
  * [Como rodar a aplicação](#como-rodar-a-aplicação)
  * [Como fazer login com usuários](#com-fazer-login-com-usuários)
  * [Documentação de API](#documentação-de-APIs)


## Configurações

  - Versão do Ruby Utilizada: Ruby 3.1.2 
  - Versão do framework Rails: 7.0.4 
  - Versão do Node: 18.12.0 
  - Ferramenta para testes: Rspec
  - HTTP Web Server: Puma 
  - Test driver: Capybara 

## Como rodar a aplicação

Antes de inicializar a aplicação, rode o comando  `bin/setup`  para instalar todas as gems e dependências necessárias para o funcionamento adequado da aplicação.
Em seguida, você pode subir a aplicação utilizando o comando  `bin/dev -p 5000`  no seu terminal, que permitirá o acesso no endereço `https://localhost:5000/`
Caso queira rodar todos os testes automatizados, utilize o comando  `rspec`

É recomendado rodar o comando  `rails db:seed`  no seu terminal para popular o banco de dados com alguns models pré-cadastrados. Dessa forma, você terá acesso a dois logins de usuários, um comum e um administrador, na qual o administrador possui alguns acessos a mais do que o usuário comum. Ao clicar no botão Fazer Login localizado na barra de navegação da página inicial, você poderá utilizar as seguintes credenciais para se autenticar como Usuário comum:

## Como fazer login com usuários
 ##### Usuário comum
  
  - Email: users@antifraudsystem.com.br
  - Senha: password

 ##### Usuário administrador
 
  Para se autenticar como Usuário administrador, clique no botão Fazer Login na barra de navegação e troque `/users/` por `/admins/` na url do navegador, e utilize as seguintes credenciais para se autenticar:
  
  - Email: admins@antifraudsystem.com.br
  - Senha: password

## Documentação de APIs

Confira aqui links de páginas da nossa wiki com a documentação das API's disponíveis da aplicação. 

* [API de Meios de Pagamento das Seguradoras](#API-Para-Obter-Meios-de-Pagamento-de-uma-Seguradora)
* [API de Promoções das Seguradoras](#API-para-obter-promoções-de-cada-seguradora)
* [API de CPFs com Denúncias Confirmadas](#API-De-CPFs-com-Denuncias-Confirmadas)
* [Endpoint para POST de cobrança](#Endpoint-para-POST-de-cobrança)

### API De Meios de Pagamento

  Para obter os meios de pagamento aceitos por uma seguradora, você pode fazer uma requisição com o verbo `GET` na seguinte URL:

  `https://localhost:5000/api/v1/payment_methods/id`

  O `id` da URL deverá ser substituído pelo `id` do meio de pagamento.

#### Status de resposta possíveis
  Status `200` | A requisição foi bem sucedida.

  Status `404` | O `id` que foi inserido na URL é inválido.

  Status `500` | Erro interno do servidor.

#### Dados

  Caso a requisição seja um sucesso, com o status `200`, a resposta será a exibição dos dados de um meio de pagamento em formato JSON, com os atributos descritos como no exemplo abaixo:

```json
{ 
  "name": "Será o nome do meio de pagamento (Cartão fulano, Banco Beltrano..)",
  "payment_type": "Será o tipo de pagamento (Crédito, Pix, Boleto...)",
  "image_url": "URL para renderizar a imagem do meio de pagamento",
  "tax_percentage": "Taxa do tipo de pagamento (Em porcentagem)",
  "tax_maximum": "Taxa máxima que pode ser cobrada (Em R$)",
}
```

### API De Meios de Pagamento das Seguradoras 

  Para obter os meios de pagamento aceitos por uma seguradora, você pode fazer uma requisição com o verbo `GET` na seguinte URL:

  `https://localhost:5000/api/v1/insurance_companies/id/payment_options`

  O `id` da URL deverá ser substituído pelo `id` da seguradora da [aplicação de seguradoras](https://github.com/TreinaDev/insurance-app)

#### Status de resposta possíveis
  Status `200` | A requisição foi bem sucedida.

  Status `404` | O `id` que foi inserido na URL é inválido.

  Status `500` | Erro interno do servidor.

#### Dados

  Caso a requisição seja um sucesso, com o status `200`, a resposta será uma lista dos meios de pagamento da seguradora em formato JSON, com os atributos descritos como no exemplo abaixo:

```json
{ 
  "payment_method_id": "ID do cadastro da opção de pagamento na aplicação de Pagamentos",
  "name": "Será o nome do meio de pagamento (Cartão fulano, Banco Beltrano..)",
  "payment_type": "Será o tipo de pagamento (Crédito, Pix, Boleto...)",
  "image_url": "URL para renderizar a imagem do meio de pagamento",
  "tax_percentage": "Taxa do tipo de pagamento (Em porcentagem)",
  "tax_maximum": "Taxa máxima que pode ser cobrada (Em R$)",
  "max_parcels": "Quantidade máxima de parcelas (Caso seja crédito)", 
  "single_parcel_discount": "Desconto para pagamento à vista (Opcional)"
}
```

### API para obter promoções de cada seguradora

  Para obter as os dados de uma promoção, você pode fazer uma requisição com o verbo `GET` na seguinte URL:

  `https://localhost:5000/api/v1/promos/VOUCHER/?product_id&price`

####  A URL deve ser montada a partir de 3 dados:

  `deve ser diretamente aplicado na url`: 
  - `voucher` é o código único do cupom da promoção. 
 
  `deve ser passado com o método o to_query em uma hash`: 

  - `product_id` é o id do produto para qual a promoção está sendo aplicada.

  - `price` é o valor final do serviço sendo contratado no sistema comparador de seguros

#### Status de resposta possíveis

  Status `200` | A requisição foi bem sucedida.

  Status `404` | O `voucher` que foi inserido na URL é inválido.

  Status `500` | Erro interno do servidor.

#### Dados

  Caso a requisição seja um sucesso, com o status `200`, a resposta será um resultado do processamento de uma promoção com os dados do cupom, do id produto e do valor final do pacote sendo vendido, em formato JSON, com os atributos descritos como no exemplo abaixo:

Promoção vencida:

```json
   { 
     "status": "Cupom expirado."
   }
```

Promoção não cadastrada, com algum dado inválido ou com uma data futura:


```json
   { 
     "status": "Cupom inválido."
   }
```

Promoção válida para todas as condições:

```json
   { 
     "status": "Cupom válido.",
     "discount": "valor do desconto"
   }
```

### API De CPFs com Denuncias Confirmadas

  Para consultar se o cpf tem uma denúncia de fraude confirmada, você pode fazer uma requisição com o verbo `GET` na seguinte URL:

  `http://localhost:5000/api/v1/blocked_registration_numbers/cpf`

####  A URL deve ser montada substituindo o `cpf` pelo CPF a ser verificado:

#### Status de resposta possíveis
  Status `200` | A requisição foi bem sucedida.

  Status `500` | Erro interno do servidor.

#### Dados

  Caso a requisição seja um sucesso, com o status `200`, a resposta será um resultado de uma consulta no banco de dados do sistema anti-fraude informando se há uma denúncia confirmada com esse CPF, em formato JSON, com os atributos descritos como no exemplo abaixo:

CPF com denúncia de fraude confirmada:

```json
   { 
     "blocked": true
   }
```

CPF não registrado ou sem denúncia de fraude confirmada:


```json
   { 
     "blocked": false
   }
```

### Endpoint para POST de cobrança

  Para enviar os dados de uma cobrança, você pode fazer uma requisição com o verbo `POST` na seguinte URL:

  `https://localhost:5000/api/v1/invoices`

#### Status de resposta possíveis

  Status `200` | A requisição foi bem sucedida.

  Status `412` | Falha em precondições.

#### Dados

  Caso a requisição seja um sucesso, com o status `200`, será exibida uma mensagem de sucesso em formato JSON:

```json
  { 
    "message": "Sucesso."
  }
```
  
  Caso a requisição envie parametros invalidos, retorna status `412` e será exibida uma mensagem de erro em formato JSON:

```json
  { 
    "errors": "mensagens de erros de validação"
  }
```

 ### Especificações do sistema
   ##### Gems utilizadas: 
  
    * FactoryBot: 
       Gem utilizada para automatizar o processo de população do banco de dados, simplificando as etapas de alguns testes e os deixando mais limpos.
  
    * Faker:
       Gem utilizada para criar dados 'falsos', associada com a FactoryBot é utilizada para gerar strings e números aleatórios que servem como valores dos atributos nas instâncias dos models.
  
    * Devise:
       Gem utilizada para gerenciar a autenticação dos usuários comuns e admins.
       
    * Faraday:
       Gem utilizada para disparar requisições HTTP, foi utilizada neste projeto com o propósito de se comunicar
       com a APi de outros sistemas.
    
    * Bootstrap:
       Gem utilizada para fazer o front-end e a estilização da aplicação.

    * Rubocop:
       Linter utilizado para garantir que o código se enquadra em padrões de boas práticas.

    * Simplecov:
       Gem utilizada para garantir uma boa cobertura de testes automatizados durante o desenvolvimento
       da aplicação. 

    * Active Storage:
       Gem utilizada para gerenciar o upload de arquivos.
    
    * Active Storage Validations:
       Gem utilizada para adicionar validações personalizadas ao active_storage.

    *ImagemProcessing/MiniMagick/LibVips:
       Gems utilizadas para processar imagem.