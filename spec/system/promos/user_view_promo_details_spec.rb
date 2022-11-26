require 'rails_helper'

describe 'Usuário vê mais detalhes de uma promoção' do
  it 'e vê informações adicionais' do
    products_url = "#{Rails.configuration.external_apis['insurance_api']}/products"
    json_data = Rails.root.join('spec/support/json/products.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    company = FactoryBot.create(:insurance_company)
    allow(SecureRandom).to receive(:alphanumeric).and_return('3MVGTOVW')
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:promo, name: 'Black Friday', starting_date: Time.zone.today,
                              ending_date: Time.zone.today + 30.days,
                              discount_max: 10_000, discount_percentage: 20, usages_max: 10,
                              insurance_company_id: company.id)

    login_as user, scope: :user
    visit promos_path
    click_on '3MVGTOVW'

    expect(page).to have_content "Data de início: #{Time.zone.today.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Data de fim: #{(Time.zone.today + 30.days).strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Quantidade de usos: 10'
    expect(page).to have_content 'Cupom: 3MVGTOVW'
    expect(page).to have_content 'Porcentagem de desconto: 20 %'
    expect(page).to have_content 'Valor máximo de desconto: R$ 100,00'
  end
end
