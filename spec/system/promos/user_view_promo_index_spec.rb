require 'rails_helper'

describe "Funcionário visita a pagina de promoção" do
  it 'e vê promoções cadastradas' do
    #arrange
    promo_a = create(:promo)
    promo_b = create(:promo)
    #act
      #login_as funcionário
    #visit root_path
    visit promos_path
    #assert
    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content "Promoção #{promo_a.name}"
    expect(page).to have_content "Promoção #{promo_b.name}"
  end

  it 'e não há promoções cadastradas' do
    #arrange
    #act
    visit promos_path
    #assert
    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content 'Nenhuma promoção cadastrada.'
  end
end
