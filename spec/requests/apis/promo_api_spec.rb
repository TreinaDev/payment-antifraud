require 'rails_helper'

describe 'Promo API' do
  context 'GET /api/v1/promos/voucher' do
    it 'com sucesso' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today + 7.days,
                                          ending_date: Time.zone.today + 30.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Black Friday')
      expect(json_response['starting_date']).to eq (Time.zone.today + 7.days).strftime('%Y-%m-%d')
      expect(json_response['ending_date']).to eq (Time.zone.today + 30.days).strftime('%Y-%m-%d')
      expect(json_response['discount_max']).to eq 100
      expect(json_response['discount_percentage']).to eq 20
      expect(json_response['usages_max']).to eq 10
      expect(json_response['insurance_company_id']).to eq company.id
      expect(json_response['voucher']).to eq '3MVGTOVW'
      expect(json_response['products']).to eq [3]
    end

    it 'e retorna não encontrado ao digitar um voucher não cadastrado' do
      get '/api/v1/promos/DIAOSMDK20329203'

      expect(response.status).to eq 404
    end

    it 'e acontece um erro interno' do
      allow(Promo).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/promos/DIAOSMSHD'

      expect(response).to have_http_status(500)
    end
  end
end
