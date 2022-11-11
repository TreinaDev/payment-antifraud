require 'rails_helper'

describe InsuranceApi do
  context '.all' do
    it 'Método devolve todas as companhias de seguro cadastradas' do
      json_data = File.read 'spec/support/json/insurance_companies.json'
      fake_response = double('Faraday::Response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies').and_return(fake_response)

      companies = InsuranceApi.all

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

      companies = InsuranceApi.all

      expect(companies).to eq []
    end
  end

  context '.active_company?' do 
    it 'Retorna true se o status da companhia e o status do token estiverem ativos' do 
      company = InsuranceApi.new(
                  id: 1,
                  email_domain: 'paolaseguros.com.br',
                  company_status: 0,
                  company_token: 'ABCDEFGHIJASPOASPO',
                  token_status: 0
      )

      result = InsuranceApi.active_company?(company)
      expect(result).to be_truthy
    end

    it 'Retorna false se o status da companhia e o status do token estiverem inativos' do 
      company = InsuranceApi.new(
                  id: 1,
                  email_domain: 'paolaseguros.com.br',
                  company_status: 1,
                  company_token: 'ABCDEFGHIJASPOASPO',
                  token_status: 1
      )

      result = InsuranceApi.active_company?(company)
      expect(result).to be_falsy
    end
  end

  context '.check_if_user_email_match_any_company' do 
    it 'Retorna a companhia que for compatível com o e-mail que o usuário inseriu, se existir' do 
      companies = []
      target_company = InsuranceApi.new(
                    id: 1,
                    email_domain: 'paolaseguros.com.br',
                    company_status: 0,
                    company_token: 'ABCDEFGHIJASPOASPO',
                    token_status: 0
                   )
      companies << target_company
      companies << InsuranceApi.new(
                    id: 2,
                    email_domain: 'petraseguros.com.br',
                    company_status: 0,
                    company_token: 'ABCDEFGHIJASPOASPO',
                    token_status: 0
                   )   
      allow(InsuranceApi).to receive(:all).and_return(companies)

      result = InsuranceApi.check_if_user_email_match_any_company('bruna@paolaseguros.com.br')

      expect(result).to eq target_company
      expect(result.email_domain).to eq 'paolaseguros.com.br'
    end

    it 'Retorna um array vazio se não houverem companhias compatíveis' do 
      companies = []
      target_company = InsuranceApi.new(
                    id: 1,
                    email_domain: 'paolaseguros.com.br',
                    company_status: 0,
                    company_token: 'ABCDEFGHIJASPOASPO',
                    token_status: 0
                   )
      companies << target_company
      companies << InsuranceApi.new(
                    id: 2,
                    email_domain: 'petraseguros.com.br',
                    company_status: 0,
                    company_token: 'ABCDEFGHIJASPOASPO',
                    token_status: 0
                   )   
      allow(InsuranceApi).to receive(:all).and_return(companies)

      result = InsuranceApi.check_if_user_email_match_any_company('bruna@EMAILQUENAOEXISTEBLUBLBULBUBLUB.com.frances')

      expect(result).to eq []
    end
  end

end
