require 'rails_helper'

describe 'Funcionário adiciona um produto a uma promoção' do
  it 'com sucesso' do
    products_url = Rails.configuration.external_apis['insurance_api_products_endpoint']
    json_data = [
      {
        id: 1,
        product_model: 'TV 32'
      },
      {
        id: 2,
        product_model: 'TV 50'
      }
    ].to_json
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    promo = FactoryBot.create(:promo, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promo.voucher
    select 'TV 32', from: 'Adicionar produto na promoção:'
    click_on 'Selecionar Produto'

    expect(page).to have_content 'Produtos inclusos nesta promoção'
    expect(page).to have_content 'Produto adicionado com sucesso.'
    expect(page).to have_content 'TV 32'
  end
  it 'e produto some da lista de seleção se já tiver sido adicionado' do
    products_url = Rails.configuration.external_apis['insurance_api_products_endpoint']
    json_data = [
      {
        id: 1,
        product_model: 'TV 32'
      },
      {
        id: 2,
        product_model: 'TV 50'
      }
    ].to_json
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    promo = FactoryBot.create(:promo, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promo.voucher
    select 'TV 32', from: 'Adicionar produto na promoção:'
    click_on 'Selecionar Produto'

    within('div#product_select') do
      expect(page).not_to have_content 'TV 32'
    end
  end

  it 'e não consegue selecionar mais produtos quando todos já foram adicionados' do
    products_url = Rails.configuration.external_apis['insurance_api_products_endpoint']
    json_data = [
      {
        id: 1,
        product_model: 'TV 32'
      },
      {
        id: 2,
        product_model: 'TV 50'
      }
    ].to_json
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    promo = FactoryBot.create(:promo, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promo.voucher
    select 'TV 32', from: 'Adicionar produto na promoção:'
    click_on 'Selecionar Produto'
    select 'TV 50', from: 'Adicionar produto na promoção:'
    click_on 'Selecionar Produto'

    expect(page).not_to have_content 'Adicionar produto na promoção:'
  end
end
