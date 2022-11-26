require 'rails_helper'

describe 'Lista de Bloqueios' do
  context 'GET /api/v1/promos/voucher' do
    it 'busca por um cpf bloqueado e encontra a mensagem de que está bloqueado' do
      create(:blocked_registration_number, registration_number: '19203910293')

      get '/api/v1/blocked_registration_numbers/19203910293'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['blocked']).to eq(true)
    end

    it 'busca por um cpf e encontra mensagem de que não está bloqueado' do
      company = create(:insurance_company)
      create(:fraud_report, registration_number: '19203910293', status: :pending,
                                       insurance_company_id: company.id)

      get '/api/v1/blocked_registration_numbers/19203910293'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['blocked']).to eq(false)
    end

    it 'busca por um cpf não cadastrado no sistema' do
      get '/api/v1/blocked_registration_numbers/192521393'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['blocked']).to eq(false)
    end

    it 'e acontece um erro interno' do
      allow(BlockedRegistrationNumber).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/blocked_registration_numbers/192521393'

      expect(response).to have_http_status(500)
    end
  end
end
