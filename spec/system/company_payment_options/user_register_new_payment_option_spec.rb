require 'rails_helper'

describe 'Usuário cria uma nova opção de pagamento para sua seguradora' do
  it 'a partir de um formulário' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Seguradora'
    within 'article header' do
      click_on 'Nova opção de pagamento'
    end

    expect(current_path).to eq new_company_payment_option_path
    expect(page).to have_content 'Nova opção de pagamento'
    expect(page).to have_field 'Tipo de Pagamento'
    expect(page).to have_field 'Quantidade máxima de parcelas'
    expect(page).to have_field 'Desconto à vista'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Nubank Crédito', payment_type: 'Cartão de Crédito')
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit new_company_payment_option_path
    select 'Banco Itaú - Boleto', from: 'Tipo de Pagamento'
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
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit new_company_payment_option_path
    fill_in 'Quantidade máxima de parcelas', with: ''
    fill_in 'Desconto à vista', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento não foi criada'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Tipo de Pagamento é obrigatório(a)'
    expect(page).to have_content 'Quantidade máxima de parcelas não pode ficar em branco'
    expect(page).to have_content 'Desconto à vista não pode ficar em branco'
  end

  it 'e tenta colocar parcelas em um meio de pagamento que não pode ser parcelado' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:payment_method, name: 'Nubank Crédito', payment_type: 'Cartão de Crédito')
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit new_company_payment_option_path
    select 'Banco Itaú - Boleto', from: 'Tipo de Pagamento'
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
    FactoryBot.create(:payment_method, name: 'Nubank Crédito', payment_type: 'Cartão de Crédito')
    FactoryBot.create(:payment_method, name: 'Banco Itaú', payment_type: 'Boleto')

    login_as user, scope: :user
    visit new_company_payment_option_path
    select 'Banco Itaú - Boleto', from: 'Tipo de Pagamento'
    fill_in 'Quantidade máxima de parcelas', with: '0'
    fill_in 'Desconto à vista', with: '0'
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento não foi criada'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Quantidade máxima de parcelas deve ser maior ou igual a 1'
  end
end
