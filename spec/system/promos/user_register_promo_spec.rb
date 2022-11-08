require 'rails_helper'

describe 'Funcionário cadastra uma promoção' do
  it 'a partir da tela inicial' do
    allow(InsuranceCompany).to receive(:user_email_match_any_company?).and_return(true)

    visit promos_path
    click_on 'Cadastrar promoção'

    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Data de início'
    expect(page).to have_field 'Data de fim'
    expect(page).to have_field 'Porcentagem de desconto'
    expect(page).to have_field 'Valor máximo de desconto'
    expect(page).to have_field 'Quantidade de usos'
    expect(page).to have_field 'Lista de produtos'
  end

  it 'com sucesso' do
    allow(InsuranceCompany).to receive(:user_email_match_any_company?).and_return(true)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDCF123')

    visit promos_path
    click_on 'Cadastrar promoção'
    fill_in 'Nome', with: 'Black Friday'
    fill_in 'Data de início', with: '2022-10-22'
    fill_in 'Data de fim', with: '2022-10-29'
    fill_in 'Porcentagem de desconto', with: 50
    fill_in 'Valor máximo de desconto', with: 100
    fill_in 'Quantidade de usos', with: 100
    fill_in 'Lista de produtos', with: 'Notebook dell i7'
    click_on 'Salvar'

    expect(page).to have_content 'Promoção cadastrada com sucesso!'
    expect(page).to have_content 'Promoção: Black Friday'
    expect(page).to have_content 'Cupom: ASDCF123'
    expect(page).to have_content 'Notebook dell i7'
  end

  it 'com dados incompletos' do
    allow(InsuranceCompany).to receive(:user_email_match_any_company?).and_return(true)

    visit promos_path
    click_on 'Cadastrar promoção'
    fill_in 'Nome', with: ''
    fill_in 'Data de início', with: ''
    fill_in 'Data de fim', with: ''
    fill_in 'Porcentagem de desconto', with: ''
    fill_in 'Valor máximo de desconto', with: ''
    fill_in 'Quantidade de usos', with: 100
    fill_in 'Lista de produtos', with: 'Notebook dell i7'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível cadastrar a promoção'
  end
end
