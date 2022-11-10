require 'rails_helper'

describe InsuranceCompany do
  context '.all' do
    it 'Método devolve todas as companhias de seguro cadastradas' do
      json_data = File.read 'spec/support/json/insurance_companies.json'
      fake_response = double('Faraday::Response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies').and_return(fake_response)
      companies = InsuranceCompany.all

      expect(companies.length).to eq 2
      expect(companies.first.id).to eq 1
      expect(companies.first.email_domain).to eq 'paolaseguros.com.br'
      expect(companies.first.company_status).to eq 0
      expect(companies.first.company_token).to eq 'ABCDEFGHIJKLMNOPQRSTWXYZ'
      expect(companies.first.token_status).to eq 0
      expect(companies[1].id).to eq 2
      expect(companies[1].email_domain).to eq 'petraseguros.com.br'
      expect(companies[1].company_status).to eq 0
      expect(companies[1].company_token).to eq 'XYZABEEBBEBEBEBEBEBEE'
      expect(companies[1].token_status).to eq 0
    end

    it 'Método devolve array vazio quando recebe um status 204(No Content) da API' do
      fake_response = double('Faraday::Response', status: 204, body: {})
      allow(Faraday).to receive(:get).with('https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies').and_return(fake_response)

      companies = InsuranceCompany.all

      expect(companies).to eq []
    end
  end

  context '.find' do 
    it 'Devolve uma seguradora se o ID for de uma seguradora ativa' do 
      json_data = File.read 'spec/support/json/insurance_company.json'
      fake_response = double('Faraday::Response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with("https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies/1").and_return(fake_response)

      company = InsuranceCompany.find(1)

      expect(company.id).to eq 1
      expect(company.email_domain).to eq 'paolaseguros.com.br'
      expect(company.company_status).to eq 0
      expect(company.company_token).to eq 'ABCDEFGHIJKLMNOPQRSTWXYZ'
      expect(company.token_status).to eq 0
    end
  end

  context '#company_payment_options' do 
    it 'Método devolve os meios de pagamento de uma seguradora, se houver algum' do 
      user = FactoryBot.create(:user, name: 'Paolitas')
      payment_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank')
      company = InsuranceCompany.new(
                  id: 1,
                  email_domain: 'paolaseguros.com.br',
                  company_status: 0,
                  company_token: 'ABLUBLUBLUEBLUBLUELU',
                  token_status: 0
      )
      payment_option = CompanyPaymentOption.create!(
                         user: user, 
                         payment_method: payment_method,
                         company_domain: user.email.split('@').last,
                         max_parcels: 6,
      )

      result = company.payment_options 

      expect(result).to eq [payment_option]
    end

    it 'Método devolve array vazio se não há meios de pagamentos cadastrados para uma seguradora' do 
      company = InsuranceCompany.new(
                  id: 1,
                  email_domain: 'paolaseguros.com.br',
                  company_status: 0,
                  company_token: 'ABLUBLUBLUEBLUBLUELU',
                  token_status: 0
      )

      result = company.payment_options 

      expect(result).to eq []
    end
  end

  context '.user_email_match_any_company?' do
    it 'Método retorna true se o email que o usuário inseriu pertence a alguma seguradora ativa' do
      companies = []
      companies << InsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 0,
        company_token: 'ABLUBLUBLUEBLUBLUELU',
        token_status: 0
      )
      companies << InsuranceCompany.new(
        id: 2,
        email_domain: 'SEGURADORANAOVALIDA.com.br',
        company_status: 1,
        company_token: 'TOKENEXPIRADODESDE1999',
        token_status: 1
      )
      allow(InsuranceCompany).to receive(:all).and_return(companies)

      user = FactoryBot.build(:user, email: 'paolaseguros.com.br')
      result = InsuranceCompany.user_email_match_any_company?(user.email)

      expect(result).to be_truthy
    end

    it 'Método retorna false se o email que o usuário inseriu NÃO pertence a uma seguradora ativa' do
      companies = []
      companies << InsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 0,
        company_token: 'ABLUBLUBLUEBLUBLUELU',
        token_status: 0
      )
      companies << InsuranceCompany.new(
        id: 2,
        email_domain: 'petraseguros.com.br',
        company_status: 0,
        company_token: 'PETRALEGALPETRALEGAL',
        token_status: 0
      )
      allow(InsuranceCompany).to receive(:all).and_return(companies)

      user = FactoryBot.build(:user, email: 'NAOEXISTEESSASEGURADORA.com.br')
      result = InsuranceCompany.user_email_match_any_company?(user.email)

      expect(result).to be_falsy
    end

    it 'Método retorna false se o email pertence a uma seguradora mas ela não está ativa' do
      companies = []
      companies << InsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 1,
        company_token: 'ABLUBLUBLUEBLUBLUELU',
        token_status: 0
      )
      companies << InsuranceCompany.new(
        id: 2,
        email_domain: 'petraseguros.com.br',
        company_status: 1,
        company_token: 'PETRALEGALPETRALEGAL',
        token_status: 0
      )
      allow(InsuranceCompany).to receive(:all).and_return(companies)

      user = FactoryBot.build(:user, email: 'petra@paolaseguros.com.br')
      result = InsuranceCompany.user_email_match_any_company?(user.email)

      expect(result).to be_falsy
    end

    it 'Método retorna false se o email pertence uma seguradora mas o token dela está expirado' do
      companies = []
      companies << InsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 0,
        company_token: 'ABLUBLUBLUEBLUBLUELU',
        token_status: 1
      )
      companies << InsuranceCompany.new(
        id: 2,
        email_domain: 'petraseguros.com.br',
        company_status: 0,
        company_token: 'PETRALEGALPETRALEGAL',
        token_status: 1
      )
      allow(InsuranceCompany).to receive(:all).and_return(companies)

      user = FactoryBot.build(:user, email: 'petra@paolaseguros.com.br')
      result = InsuranceCompany.user_email_match_any_company?(user.email)

      expect(result).to be_falsy
    end
  end


end

