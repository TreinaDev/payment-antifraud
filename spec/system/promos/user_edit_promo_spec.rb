require 'rails_helper'

describe 'Funcionário edita uma promoção' do
  it 'a partir da tela de show' do
    promo = create(:promo, name: 'Promoção Páscoa', usages_max: 50)
    admin = FactoryBot.create(:admin)

    login_as admin, scope: :admin
    visit promos_path
    click_on promo.name
    click_on 'Editar'

    expect(page).to have_content 'Editar Promoção'
    expect(page).to have_field 'Nome', with: promo.name
    expect(page).to have_field 'Data de início', with: promo.starting_date
    expect(page).to have_field 'Data de fim', with: promo.ending_date
    expect(page).to have_field 'Lista de produtos', with: promo.product_list
    expect(page).to have_field 'Data de fim', with: promo.ending_date
    expect(page).to have_field 'Porcentagem de desconto', with: promo.discount_percentage
    expect(page).to have_field 'Valor máximo de desconto', with: promo.discount_max
    expect(page).to have_field 'Quantidade de usos', with: 50
  end

  it 'com sucesso' do
    promo = create(:promo, name: 'Promoção de Páscoa', usages_max: 10)
    admin = FactoryBot.create(:admin)

    login_as admin, scope: :admin
    visit promos_path
    click_on promo.name
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
