require 'rails_helper'

describe 'Funcionário visita a pagina de promoção' do
  it 'e vê promoções cadastradas' do
    promo_a = create(:promo)
    promo_b = create(:promo)
    admin = FactoryBot.create(:admin)
    
    login_as admin, scope: :admin
    visit promos_path

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content "Promoção: #{promo_a.name}"
    expect(page).to have_content "Promoção: #{promo_b.name}"
  end

  it 'e não há promoções cadastradas' do
    admin = FactoryBot.create(:admin)
    
    login_as admin, scope: :admin
    visit promos_path

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content 'Nenhuma promoção cadastrada.'
  end
end
