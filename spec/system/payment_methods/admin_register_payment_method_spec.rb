require 'rails_helper'

describe 'Usuário cadastra novo meio de pagamento' do
  it 'e está autenticado como administrador' do
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'

    expect(page).to have_link 'Cadastrar Novo Meio de Pagamento'
  end

  it 'a partir do menu' do
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Cadastrar Novo Meio de Pagamento'

    expect(current_url).to eq new_payment_method_url
    expect(page).to have_content 'Cadastrar Novo Meio de Pagamento'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Taxa por Cobrança'
    expect(page).to have_field 'Taxa Máxima'
    expect(page).to have_field 'Quantidade máxima de parcelas'
    expect(page).to have_field 'Tipo de Pagamento'
    expect(page).to have_field 'Ícone'
    expect(page).to have_button 'Salvar'
  end

  it 'com sucesso' do
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Cadastrar Novo Meio de Pagamento'
    fill_in 'Nome', with: 'Cartão Roxinho'
    fill_in 'Taxa por Cobrança', with: 5
    fill_in 'Taxa Máxima', with: 2
    fill_in 'Quantidade máxima de parcelas', with: 12
    select 'Cartão de Crédito', from: 'Tipo de Pagamento'
    attach_file 'Ícone', Rails.root.join('spec/support/icone_cartao_credito_azul.jpg')
    click_on 'Salvar'

    expect(current_url).to eq payment_method_url(1)
    expect(page).to have_content 'Meio de Pagamento registrado com sucesso.'
    expect(page).to have_content 'Detalhes do Meio de Pagamento'
    expect(page).to have_content 'Cartão Roxinho'
    expect(page).to have_content 'Taxa por Cobrança: 5%'
    expect(page).to have_content 'Taxa Máxima: R$ 2,00'
    expect(page).to have_content 'Tipo de Pagamento: Cartão de Crédito'
    expect(page).to have_css 'img[src*="icone_cartao_credito_azul.jpg"]'
    expect(page).to have_content 'Status: Ativo'
  end

  it 'com informações faltando' do
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Cadastrar Novo Meio de Pagamento'
    fill_in 'Nome', with: ''
    fill_in 'Taxa por Cobrança', with: ''
    fill_in 'Taxa Máxima', with: ''
    fill_in 'Quantidade máxima de parcelas', with: ''
    select 'Cartão de Crédito', from: 'Tipo de Pagamento'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível registrar o meio de pagamento.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Taxa por Cobrança não pode ficar em branco'
    expect(page).to have_content 'Taxa Máxima não pode ficar em branco'
    expect(page).to have_content 'Ícone não pode ficar em branco'
  end
end
