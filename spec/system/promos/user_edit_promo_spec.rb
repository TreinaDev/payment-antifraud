require 'rails_helper'

describe 'Funcionário edita uma promoção' do
  it 'a partir da tela de show' do
    products_url = "#{Rails.configuration.external_apis['insurance_api']}/products"
    json_data = Rails.root.join('spec/support/json/products.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    company = create(:insurance_company)
    promo = create(:promo, name: 'Promoção Páscoa', usages_max: 50, discount_max: 1000,
                           insurance_company_id: company.id)
    user = create(:user, insurance_company_id: company.id)

    login_as user, scope: :user
    visit promos_path
    click_on promo.voucher
    click_on 'Editar'

    expect(page).to have_content 'Editar Promoção'
    expect(page).to have_field 'Nome', with: promo.name
    expect(page).to have_field 'Data de início', with: promo.starting_date
    expect(page).to have_field 'Data de fim', with: promo.ending_date
    expect(page).to have_field 'Data de fim', with: promo.ending_date
    expect(page).to have_field 'Porcentagem de desconto', with: promo.discount_percentage
    expect(page).to have_field 'Valor máximo de desconto', with: 10
    expect(page).to have_field 'Quantidade de usos', with: 50
  end

  it 'com sucesso' do
    products_url = "#{Rails.configuration.external_apis['insurance_api']}/products"
    json_data = Rails.root.join('spec/support/json/products.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with(products_url).and_return(fake_response)
    company = create(:insurance_company)
    promo = create(:promo, name: 'Promoção de Páscoa', usages_max: 10, insurance_company_id: company.id)
    user = create(:user, insurance_company_id: company.id)

    login_as user, scope: :user
    visit promos_path
    click_on promo.voucher
    click_on 'Editar'
    fill_in 'Nome', with: 'Promoção Natal'
    fill_in 'Quantidade de usos', with: 3
    click_on 'Salvar'

    expect(current_path).to eq promo_path(promo.id)
    expect(page).to have_content 'Promoção atualizada com sucesso!'
    expect(page).to have_content 'Promoção Natal'
    expect(page).to have_content 'Quantidade de usos: 3'
    expect(page).not_to have_content 'Promoção de Páscoa'
    expect(page).not_to have_content 'Quantidade de usos: 10'
  end
end
