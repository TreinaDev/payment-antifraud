require 'rails_helper'

describe 'Funcionário visita a pagina de promoção' do
  it 'e vê promoções cadastradas' do
    promo_a = create(:promo)
    promo_b = create(:promo)
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    within('nav') do
      click_on 'Promoções'
    end

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content promo_a.name
    expect(page).to have_content promo_b.name
  end

  it 'e não há promoções cadastradas' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    within('nav') do
      click_on 'Promoções'
    end

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content 'Nenhuma promoção cadastrada'
  end
end
