require 'rails_helper'

describe 'CompanyPaymentOptionAPI' do
  context 'GET/api/v1/company_payment_options/id' do
    it 'Usuário obtem dados de meio de pagamento da seguradora' do
      company = FactoryBot.create(:insurance_company, external_insurance_company: 1)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      first_payment_method = FactoryBot.create(
        :payment_method, name: 'Cartão Nubank',
                         payment_type: 'Cartão de Crédito',
                         tax_percentage: 2, tax_maximum: 10
      )
      second_payment_method = FactoryBot.create(
        :payment_method, name: 'Banco Sanxander',
                         payment_type: 'Boleto', tax_percentage: 1,
                         tax_maximum: 5
      )
      FactoryBot.create(
        :company_payment_option,
        user:,
        insurance_company: company,
        payment_method: first_payment_method,
        max_parcels: 12,
        single_parcel_discount: 0
      )
      FactoryBot.create(
        :company_payment_option,
        user:,
        insurance_company: company,
        payment_method: second_payment_method,
        max_parcels: 1,
        single_parcel_discount: 1
      )

      get '/api/v1/insurance_companies/1/payment_options'

      expect(response).to have_http_status 200
      expect(response.content_type).to include 'application/json'
      json_data = JSON.parse(response.body)
      expect(json_data.first['name']).to eq 'Cartão Nubank'
      expect(json_data.first['payment_type']).to eq 'Cartão de Crédito'
      expect(json_data.first['tax_percentage']).to eq 2
      expect(json_data.first['tax_maximum']).to eq 10
      expect(json_data.first['max_parcels']).to eq 12
      expect(json_data.first['single_parcel_discount']).to eq 0
      expect(json_data[1]['name']).to eq 'Banco Sanxander'
      expect(json_data[1]['payment_type']).to eq 'Boleto'
      expect(json_data[1]['tax_percentage']).to eq 1
      expect(json_data[1]['tax_maximum']).to eq 5
      expect(json_data[1]['max_parcels']).to eq 1
      expect(json_data[1]['single_parcel_discount']).to eq 1
      expect(json_data.first.keys).not_to include 'created_at'
      expect(json_data.first.keys).not_to include 'updated_at'
      expect(json_data[1].keys).not_to include 'created_at'
      expect(json_data[1].keys).not_to include 'updated_at'
    end

    it 'e passa um ID inválido como parâmetro' do
      get '/api/v1/insurance_companies/BUBLULULUGLUGLEGLUGLE9999999/payment_options'

      expect(response).to have_http_status 404
    end

    it 'e ocorre um erro interno' do
      allow(InsuranceCompany).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get '/api/v1/insurance_companies/1/payment_options'

      expect(response).to have_http_status 500
    end
  end
end
