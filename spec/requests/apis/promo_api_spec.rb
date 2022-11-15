require 'rails_helper'

describe 'Promo API' do
  context 'GET /api/v1/promos/1' do
    it 'com sucesso' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today, 
                                ending_date: Time.zone.today + 30.days,
                                discount_max: 100, discount_percentage: 20, usages_max: 10, 
                                insurance_company_id: company.id)

      get "/api/v1/promos/#{promo.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq('Black Friday')
      expect(json_response["starting_date"]).to eq Time.zone.today.strftime('%Y-%m-%d')
      expect(json_response["ending_date"]).to eq (Time.zone.today + 30.days).strftime('%Y-%m-%d')
      expect(json_response["discount_max"]).to eq 100
      expect(json_response["discount_percentage"]).to eq 20
      expect(json_response["usages_max"]).to eq 10
      expect(json_response["insurance_company_id"]).to eq company.id
      expect(json_response["voucher"]).to eq '3MVGTOVW'
      expect(json_response.keys).not_to include("created_at")
      expect(json_response.keys).not_to include("updated_at")
    end

    it 'e falha se a promoção não for encontrada' do
      get "/api/v1/promos/999999999"

      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/promos/' do
    it 'com sucesso' do
      company = FactoryBot.create(:insurance_company)
      allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
      promo_a = FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today + 7.days, 
                                ending_date: Time.zone.today + 30.days,
                                discount_max: 100, discount_percentage: 20, usages_max: 10, 
                                insurance_company_id: company.id)
      allow(SecureRandom).to receive(:alphanumeric).and_return('TOVW3MVG')
      promo_b = FactoryBot.create(:promo, name: 'Promo Natal', starting_date: Time.zone.today, 
                                ending_date: Time.zone.today + 20.days,
                                discount_max: 500, discount_percentage: 10, usages_max: 15, 
                                insurance_company_id: company.id)

      get "/api/v1/promos/"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to eq('Black Friday')
      expect(json_response[0]["starting_date"]).to eq (Time.zone.today + 7.days).strftime('%Y-%m-%d')
      expect(json_response[0]["ending_date"]).to eq (Time.zone.today + 30.days).strftime('%Y-%m-%d')
      expect(json_response[0]["discount_max"]).to eq 100
      expect(json_response[0]["discount_percentage"]).to eq 20
      expect(json_response[0]["usages_max"]).to eq 10
      expect(json_response[0]["insurance_company_id"]).to eq company.id
      expect(json_response[0]["voucher"]).to eq '3MVGTOVW'
      expect(json_response[1]["name"]).to eq('Promo Natal')
      expect(json_response[1]["starting_date"]).to eq (Time.zone.today).strftime('%Y-%m-%d')
      expect(json_response[1]["ending_date"]).to eq (Time.zone.today + 20.days).strftime('%Y-%m-%d')
      expect(json_response[1]["discount_max"]).to eq 500
      expect(json_response[1]["discount_percentage"]).to eq 10
      expect(json_response[1]["usages_max"]).to eq 15
      expect(json_response[1]["insurance_company_id"]).to eq company.id
      expect(json_response[1]["voucher"]).to eq '3MVGTOVW'
      # expect(json_response.keys).not_to include("created_at")
      # expect(json_response.keys).not_to include("updated_at")
      # como colocar voucher com outro numero
    end 

    it 'e retorna vazio se não houver promoções cadastradas' do

      get "/api/v1/promos/"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response). to eq []
    end

    it 'e acontece um erro interno' do
      allow(Promo).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/promos'

      expect(response).to have_http_status(500)
    end
  end
end
