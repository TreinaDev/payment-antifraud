require 'rails_helper'

describe 'Promo API' do
  context 'GET /api/v1/promos/voucher' do
    it 'e acessa um cupom válido, cujo desconto é o valor máximo de desconto' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today - 7.days,
                                          ending_date: Time.zone.today + 30.days,
                                          discount_max: 60, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW/?product_id=3&price=500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom válido.')
      expect(json_response['discount']).to eq(60)
    end

    it 'e acessa um cupom válido, cujo desconto é menor que o valor máximo de desconto' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today - 7.days,
                                          ending_date: Time.zone.today + 30.days,
                                          discount_max: 200, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW/?product_id=3&price=500.33'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom válido.')
      expect(json_response['discount']).to eq(100.06)
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

    it 'cupom existe e está expirado por data' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today - 30.days,
                                          ending_date: Time.zone.today - 7.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW/?product_id=3&price=500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom expirado.')
    end

    it 'cupom existe e promoção tem data futura' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today + 30.days,
                                          ending_date: Time.zone.today + 40.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW/?product_id=3&price=500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom inválido.')
    end

    it 'cupom existe e promoção não é valida para o produto buscado' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today - 30.days,
                                          ending_date: Time.zone.today + 40.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW/?product_id=5&price=500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom inválido.')
    end

    it 'cupom existe e está expirado por número de usos' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      payment_method = create(:payment_method)
      insurance_company = create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: insurance_company.id)
      FactoryBot.create(:company_payment_option, insurance_company_id: insurance_company.id,
                                                 payment_method_id: payment_method.id, user:)
      promo_a = FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today - 30.days,
                                          ending_date: Time.zone.today + 40.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 1,
                                          insurance_company_id: insurance_company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)
      Invoice.create!(payment_method:,
                      order_id: 1, registration_number: '12345678987', status: 0,
                      package_id: 1, insurance_company_id: insurance_company.id, voucher: '3MVGTOVW',
                      total_price: 10, parcels: 2)

      get '/api/v1/promos/3MVGTOVW/?product_id=3&price=500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom expirado.')
    end

    it 'e o parâmetro "price" não é fornecido' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today - 30.days,
                                          ending_date: Time.zone.today + 40.days,
                                          discount_max: 100, discount_percentage: 20, usages_max: 10,
                                          insurance_company_id: company.id)
      FactoryBot.create(:promo_product, promo: promo_a, product_id: 3)

      get '/api/v1/promos/3MVGTOVW/?product_id=3'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom válido.')
      expect(json_response['discount']).to eq 0.0
    end

    it 'e o parâmetro "product_id" não é fornecido' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      FactoryBot.create(:promo, name: 'Promo Petra', starting_date: Time.zone.today - 30.days,
                                ending_date: Time.zone.today + 40.days,
                                discount_max: 100, discount_percentage: 20, usages_max: 10,
                                insurance_company_id: company.id)

      get '/api/v1/promos/3MVGTOVW/?price=500'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Cupom inválido.')
    end
  end
end
