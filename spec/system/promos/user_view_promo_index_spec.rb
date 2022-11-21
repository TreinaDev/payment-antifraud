require 'rails_helper'

describe 'Funcionário visita a pagina de promoção' do
  it 'e vê promoções cadastradas por usuários da sua seguradora' do
    company = FactoryBot.create(:insurance_company)
    promo_a = create(:promo, insurance_company_id: company.id)
    promo_b = create(:promo, insurance_company_id: company.id)
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
    within 'article footer .pagination' do
      expect(page).to have_content 'Primeira'
      expect(page).to have_content '< Anterior'
      expect(page).to have_content 'Página 1 de 1'
      expect(page).to have_content 'Próxima >'
      expect(page).to have_content 'Última'
    end
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

  it 'e não vê promoções de outras seguradoras' do
    company_a = FactoryBot.create(:insurance_company)
    company_b = FactoryBot.create(:insurance_company)
    promo_a = create(:promo, insurance_company_id: company_a.id)
    promo_b = create(:promo, insurance_company_id: company_b.id)
    user = FactoryBot.create(:user, insurance_company_id: company_a.id)

    login_as user, scope: :user
    visit root_path
    within('nav') do
      click_on 'Promoções'
    end

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content promo_a.name
    expect(page).not_to have_content promo_b.name
  end
end
