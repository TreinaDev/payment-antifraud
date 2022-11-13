require 'rails_helper'

describe 'Funcionário adiciona um produto a uma promoção' do
  it 'com sucesso' do
    products_url = Rails.configuration.external_apis['insurance_api_products_endpoint']
    json_data = Rails.root.join('spec/support/json/products.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    user = FactoryBot.create(:user)
    promo = FactoryBot.create(:promo)

    login_as user, scope: :user
    visit root_path
    within('nav') do
      click_on 'Promoções'
    end
    click_on promo.voucher
    select 'TV 32', from: 'Lista de Produtos'
    click_on 'Enviar'

    expect(page).to have_content 'Produtos inclusos nesta promoção'
    expect(page).to have_content 'Produto adicionado com sucesso.'
    expect(page).to have_content 'TV 32'
  end
end
