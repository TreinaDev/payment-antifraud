require 'rails_helper'

describe 'Administrador cadastra novo meio de pagamento' do
  it 'a partir do menu' do
    # admin = Admin.create(name: 'Maria', email: 'maria@seguradorax.com', password: 'senha123')

    # login_as(admin)
    visit new_payment_method_url
    # visit 'root_path'
    # click_on 'Cadastrar Novo Meio de Pagamento'

    expect(current_url).to eq new_payment_method_url
    expect(page).to have_content 'Cadastrar Novo Meio de Pagamento'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Taxa por Cobrança'
    expect(page).to have_field 'Taxa Máxima'
    expect(page).to have_field 'Tipo de Pagamento'
    expect(page).to have_button 'Salvar'
  end

  it 'com sucesso' do
    visit new_payment_method_url
    fill_in 'Nome', with: 'Cartão Roxinho'
    fill_in 'Taxa por Cobrança', with: 5
    fill_in 'Taxa Máxima', with: 2
    select 'Cartão de Crédito', from: 'Tipo de Pagamento'
    click_on 'Salvar'

    expect(current_url).to eq payment_method_url(1)
    expect(page).to have_content 'Meio de Pagamento registrado com sucesso.'
    expect(page).to have_content 'Detalhes do Meio de Pagamento'
    expect(page).to have_content 'Nome: Cartão Roxinho'
    expect(page).to have_content 'Taxa por Cobrança: 5'
    expect(page).to have_content 'Taxa Máxima: 2'
    expect(page).to have_content 'Tipo de Pagamento: Cartão de Crédito'
  end

  it 'com informações faltando' do
    visit new_payment_method_url
    fill_in 'Nome', with: ''
    fill_in 'Taxa por Cobrança', with: ''
    fill_in 'Taxa Máxima', with: ''
    select 'Cartão de Crédito', from: 'Tipo de Pagamento'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível registrar o meio de pagamento.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Taxa por Cobrança não pode ficar em branco'
    expect(page).to have_content 'Taxa Máxima não pode ficar em branco'
  end
end
