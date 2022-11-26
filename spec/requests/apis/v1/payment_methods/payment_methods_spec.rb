require 'rails_helper'

describe 'CompanyPaymentOptionAPI' do
  context 'GET/api/v1/payment_methods/id' do
    it 'Usuário obtem dados de um metodo de pagamento' do
      payment_method = create(
        :payment_method, name: 'Cartão Nubank',
                         payment_type: 'Cartão de Crédito',
                         tax_percentage: 2, tax_maximum: 10
      )

      get "/api/v1/payment_methods/#{payment_method.id}"

      expect(response).to have_http_status 200
      expect(response.content_type).to include 'application/json'
      json_data = JSON.parse(response.body)
      expect(json_data['name']).to eq 'Cartão Nubank'
      expect(json_data['payment_type']).to eq 'Cartão de Crédito'
      expect(json_data['tax_percentage']).to eq 2
      expect(json_data['tax_maximum']).to eq 10
      expect(json_data.keys).not_to include 'created_at'
      expect(json_data.keys).not_to include 'updated_at'
      expect(json_data.keys).to include 'image_url'
    end

    it 'e passa um ID inválido como parâmetro' do
      get '/api/v1/payment_methods/BUBLULULUGLUGLEGLUGLE9999999/'

      expect(response).to have_http_status 404
    end

    it 'e ocorre um erro interno' do
      allow(PaymentMethod).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)

      get '/api/v1/payment_methods/1'

      expect(response).to have_http_status 500
    end
  end
end
