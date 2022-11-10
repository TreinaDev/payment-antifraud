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
end
