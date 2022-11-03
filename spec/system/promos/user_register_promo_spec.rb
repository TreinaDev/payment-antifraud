require 'rails_helper'

describe "Funcionário cadastra uma promoção" do
  it 'a partir da tela inicial' do
    #arrange
    #act
    #visit root_path
    visit promos_path
    click_on 'Cadastrar promoção'
    #assert
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_field('Nome')
    expect(page).to have_field('Data de início')
    expect(page).to have_field('Data de fim')
    expect(page).to have_field('Porcentagem de desconto')
    expect(page).to have_field('Valor máximo de desconto')
    expect(page).to have_field('Quantidade de usos')
    expect(page).to have_field('Produtos')
  end
end

