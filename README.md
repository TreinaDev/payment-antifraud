### Configurações

- Versão do Ruby Utilizada: Ruby 3.1.2 
- Versão do framework Rails: 7.0.4 
- Versão do Node: 18.12.0 
- Ferramenta para testes: Rspec
- HTTP Web Server: Puma 
- Test driver: Capybara 

Confira abaixo as outras aplicações que conversam com o nosso sistema para criar um ecossistema de seguros:

##### [Sistema de Seguradoras](https://github.com/TreinaDev/insurance-app)

##### [Sistema Comparador de Seguros](https://github.com/TreinaDev/insurance-comparator-app)

### Documentação de API's e extras

Confira aqui links de páginas da nossa wiki com a documentação das API's disponíveis da aplicação. 

##### [API De Meios de Pagamento das Seguradoras](https://github.com/TreinaDev/payment-antifraud/wiki/API-Para-Obter-Meios-de-Pagamento-de-uma-Seguradora)

##### [API De Promoções das Seguradoras](https://github.com/TreinaDev/payment-antifraud/wiki/API-para-obter-promo%C3%A7%C3%B5es-de-cada-seguradora)

##### [API De CPFs com Denuncias Confirmadas](https://github.com/TreinaDev/payment-antifraud/wiki/API-De-CPFs-com-Denuncias-Confirmadas)

##### [Endpoint para POST de cobrança](https://github.com/TreinaDev/payment-antifraud/wiki/Endpoint-para-POST-de-cobran%C3%A7a)

### Setup da aplicação

Antes de inicializar a aplicação, rode o comando  `bin/setup`  para instalar todas as gems e dependências necessárias para o funcionamento adequado da aplicação.
Em seguida, você pode subir a aplicação utilizando o comando  `bin/dev -p 5000`  no seu terminal, que permitirá o acesso no endereço `https://localhost:5000/`
Caso queira rodar todos os testes automatizados, utilize o comando  `rspec`

É recomendado rodar o comando  `rails db:seed`  no seu terminal para popular o banco de dados com alguns models pré-cadastrados. Dessa forma, você terá acesso a dois logins de usuários, um comum e um administrador, na qual o administrador possui alguns acessos a mais do que o usuário comum. Ao clicar no botão Fazer Login localizado na barra de navegação da página inicial, você poderá utilizar as seguintes credenciais para se autenticar como Usuário comum:

 ##### Usuário comum
  - Email: users@antifraudsystem.com.br
  - Senha: password

Para se autenticar como Usuário administrador, clique no botão Fazer Login na barra de navegação e troque /users/ por /admins/ na url do navegador, e utílize as seguintes credenciais para se autenticar: 

 ##### Usuário administrador
  - Email: admins@antifraudsystem.com.br
  - Senha: password

 ### Specs do sistema
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