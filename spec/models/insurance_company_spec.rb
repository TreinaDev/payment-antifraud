require 'rails_helper'

RSpec.describe InsuranceCompany, type: :model do
  context '.all_external' do
    it 'Método devolve todas as companhias de seguro cadastradas' do
      companies_url = "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies"
      json_data = File.read 'spec/support/json/insurance_companies.json'
      fake_response = double('Faraday::Response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with(companies_url).and_return(fake_response)

      companies = InsuranceCompany.all_external

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
      companies_url = "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies"
      fake_response = double('Faraday::Response', status: 204, body: {})
      allow(Faraday).to receive(:get).with(companies_url).and_return(fake_response)

      companies = InsuranceCompany.all_external

      expect(companies).to eq []
    end
  end

  context '.active_external_company?' do
    it 'Retorna true se o status da companhia e o status do token estiverem ativos' do
      company = ExternalInsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 0,
        company_token: 'ABCDEFGHIJASPOASPO',
        token_status: 0
      )

      result = InsuranceCompany.active_external_company?(company)
      expect(result).to be_truthy
    end

    it 'Retorna false se o status da companhia e o status do token estiverem inativos' do
      company = ExternalInsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 1,
        company_token: 'ABCDEFGHIJASPOASPO',
        token_status: 1
      )

      result = InsuranceCompany.active_external_company?(company)
      expect(result).to be_falsy
    end
  end

  context '.check_if_user_email_match_any_external_company' do
    it 'Retorna a companhia que for compatível com o e-mail que o usuário inseriu, se existir' do
      companies = []
      target_company = ExternalInsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 0,
        company_token: 'ABCDEFGHIJASPOASPO',
        token_status: 0
      )
      companies << target_company
      companies << ExternalInsuranceCompany.new(
        id: 2,
        email_domain: 'petraseguros.com.br',
        company_status: 0,
        company_token: 'ABCDEFGHIJASPOASPO',
        token_status: 0
      )
      allow(InsuranceCompany).to receive(:all_external).and_return(companies)

      result = InsuranceCompany.check_if_user_email_match_any_external_company('bruna@paolaseguros.com.br')

      expect(result).to eq target_company
      expect(result.email_domain).to eq 'paolaseguros.com.br'
    end

    it 'Retorna um array vazio se não houverem companhias compatíveis' do
      companies = []
      target_company = ExternalInsuranceCompany.new(
        id: 1,
        email_domain: 'paolaseguros.com.br',
        company_status: 0,
        company_token: 'ABCDEFGHIJASPOASPO',
        token_status: 0
      )
      companies << target_company
      companies << ExternalInsuranceCompany.new(
        id: 2,
        email_domain: 'petraseguros.com.br',
        company_status: 0,
        company_token: 'ABCDEFGHIJASPOASPO',
        token_status: 0
      )
      allow(InsuranceCompany).to receive(:all_external).and_return(companies)

      result = InsuranceCompany.check_if_user_email_match_any_external_company('bruna@EMAILQUENAOEXISTEBLUB.frances')

      expect(result).to eq []
    end
  end
end
