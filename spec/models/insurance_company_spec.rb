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

  describe '.check_if_company_exists_locally' do
    context 'Verifica se a seguradora possui registro na aplicação' do
      it 'e devolve a seguradora existente' do
        external_company_data = {
          id: 10,
          email_domain: 'paolaseguros.com.br',
          company_status: 0,
          company_token: 'TOKENEXPIRADODESDE1999',
          token_status: 0
        }
        local_company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
        result = InsuranceCompany.check_if_external_company_exists_locally(external_company_data)

        expect(result).to eq local_company
        expect(result.external_insurance_company).to eq 10
      end

      it 'e cria um novo registro para a seguradora' do
        external_company_data = {
          id: 10,
          email_domain: 'paolaseguros.com.br',
          company_status: 0,
          company_token: 'TOKENEXPIRADODESDE1999',
          token_status: 0
        }
        result = InsuranceCompany.check_if_external_company_exists_locally(external_company_data)

        expect(result.instance_of?(InsuranceCompany)).to be_truthy
        expect(InsuranceCompany.count).to eq 1
      end
    end
  end
end
