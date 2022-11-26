require 'rails_helper'

describe 'Funcionário remove um produto a uma promoção' do
  it 'com sucesso' do
    products_url = "#{Rails.configuration.external_apis['insurance_api']}/products"
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
    visit promos_path
    click_on promo.voucher
    select 'TV 32', from: 'Adicionar produto na promoção:'
    click_on 'Selecionar Produto'
    select 'TV 50', from: 'Adicionar produto na promoção:'
    click_on 'Selecionar Produto'
    within('div#1') do
      click_on 'Remover'
    end

    expect(page).to have_content 'Produto removido com sucesso.'
    expect(page).to have_content 'TV 50'
  end
end
