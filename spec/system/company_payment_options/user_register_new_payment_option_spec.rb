require 'rails_helper'

describe 'Usuário configura uma nova opção de pagamento para sua seguradora' do
  it 'a partir de um meio de pagamento' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Nubank Crédito', payment_type: 'Cartão de Crédito')

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Seguradora'
    click_on 'Configurar'

    expect(current_path).to eq new_company_payment_option_path
    expect(page).to have_content 'Configurar nova opção de pagamento'
    expect(page).to have_field 'Quantidade máxima de parcelas'
    expect(page).to have_field 'Desconto à vista'
    expect(page).to have_button 'Enviar'
  end

  it 'e não existem meios de pagamento disponíveis para configurar' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Seguradora'

    expect(page).to have_content 'Não há meios de pagamento disponíveis'
    expect(page).to have_content 'Meios de pagamento disponíveis'
    expect(page).not_to have_content 'Nome'
    expect(page).not_to have_content 'Tipo de Pagamento'
    expect(page).not_to have_content 'Taxa por Cobrança'
    expect(page).not_to have_content 'Taxa Máxima	'
    expect(page).not_to have_content 'Configurar Meio de Pagamento'
  end

  it 'com sucesso' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit company_payment_options_path
    click_on 'Configurar'
    fill_in 'Quantidade máxima de parcelas', with: '1'
    fill_in 'Desconto à vista', with: '0'
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento criada com sucesso'
    expect(page).to have_content 'Detalhes da opção de pagamento'
    expect(page).to have_content 'Opção de Pagamento: Banco Itaú'
    expect(page).to have_content 'Quantidade máxima de parcelas: 1x'
    expect(page).to have_content 'Desconto à vista: Não Possui'
  end

  it 'e não preenche todos os campos' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Nubank Crédito', payment_type: 'Cartão de Crédito')

    login_as user, scope: :user
    visit company_payment_options_path
    click_on 'Configurar'
    fill_in 'Quantidade máxima de parcelas', with: ''
    fill_in 'Desconto à vista', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento não foi criada'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Quantidade máxima de parcelas não pode ficar em branco'
    expect(page).to have_content 'Desconto à vista não pode ficar em branco'
  end

  it 'e tenta colocar parcelas em um meio de pagamento que não pode ser parcelado' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit company_payment_options_path
    click_on 'Configurar'
    fill_in 'Quantidade máxima de parcelas', with: '10'
    fill_in 'Desconto à vista', with: '0'
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento não foi criada'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Tipo de Pagamento não pode ser parcelado'
  end

  it 'e preenche parcelas com 0' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit company_payment_options_path
    click_on 'Configurar'
    fill_in 'Quantidade máxima de parcelas', with: '0'
    fill_in 'Desconto à vista', with: '0'
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento não foi criada'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Quantidade máxima de parcelas deve ser maior ou igual a 1'
  end
end
