require 'rails_helper'

describe 'Promo API' do
  context 'GET /api/v1/promos/voucher' do
    it 'e acessa um cupom válido' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today - 7.days,
                                          ending_date: Time.zone.today + 30.days,
                                          discount_max: 60, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3-3MVGTOVW-500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom válido.')
      expect(json_response['discount']).to eq(60)
    end

    it 'e retorna não encontrado ao digitar um cupom não cadastrado' do
      get '/api/v1/promos/DIAOSMDK20329203'

      expect(response.status).to eq 404
    end

    it 'e acontece um erro interno' do
      allow(Promo).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/promos/099999999999999231030130013'

      expect(response).to have_http_status(500)
    end

    it 'cupom é válido e está expirado por data' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today - 30.days,
                                          ending_date: Time.zone.today - 7.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3-3MVGTOVW-500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom expirado.')
    end

    it 'cupom é válido e promoção tem data futura' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today + 30.days,
                                          ending_date: Time.zone.today + 40.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3-3MVGTOVW-500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom inválido.')
    end

    it 'cupom é válido e promoção não é valida para o produto buscado' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today - 30.days,
                                          ending_date: Time.zone.today + 40.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/5-3MVGTOVW-500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom inválido.')
    end
  end
end
