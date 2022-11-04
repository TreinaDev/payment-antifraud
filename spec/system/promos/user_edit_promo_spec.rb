require 'rails_helper'

describe 'Funcionário edita uma promoção' do
  it 'a partir da tela de show' do
    #login_as
    promo = create(:promo)
    
    # visit root_path
    visit promos_path
    click_on promo.name
    click_on 'Editar'

    expect(page).to have_content 'Editar Promoção'
    expect(page).to have_field 'Nome', with: promo.name
    expect(page).to have_field 'Data de início', with: promo.starting_date
    expect(page).to have_field 'Data de fim', with: promo.ending_date
    expect(page).to have_field 'Lista de produtos', with: promo.product_list
    expect(page).to have_field 'Data de fim', with: promo.ending_date


    expect(page).to have_content "Data de início: #{I18n.localize(Date.today)}"
  end

end
