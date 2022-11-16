require 'rails_helper'

describe 'Usuário edita opção de pagamento para sua seguradora' do
  it 'a partir de um formulário' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
    FactoryBot.create(
      :company_payment_option,
      user:,
      insurance_company: company,
      payment_method:,
      max_parcels: 12,
      single_parcel_discount: 0
    )

    login_as user, scope: :user
    visit root_path
    click_on 'Minha Seguradora'
    click_on 'Cartão Nubank'
    click_on 'Editar'

    expect(page).to have_content 'Editar opção de pagamento'
    expect(page).to have_field 'Quantidade máxima de parcelas', with: '12'
    expect(page).to have_field 'Desconto à vista', with: '0'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(
      :user, insurance_company_id: company.id,
             name: 'Paola', email: 'paola@sistemadefraude.com.br'
    )
    first_pay_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
    payment_option = FactoryBot.create(
      :company_payment_option,
      user:,
      insurance_company: company,
      payment_method: first_pay_method,
      max_parcels: 12,
      single_parcel_discount: 0
    )

    login_as user, scope: :user
    visit edit_company_payment_option_path(payment_option)

    fill_in 'Quantidade máxima de parcelas', with: '1'
    fill_in 'Desconto à vista', with: '5'
    click_on 'Enviar'

    expect(current_path).to eq company_payment_option_path(payment_option.id)
    expect(page).to have_content 'Opção de pagamento editada com sucesso'
    expect(page).to have_content 'Opção de Pagamento: Cartão Nubank'
    expect(page).to have_content 'Tipo de Pagamento: Cartão de Crédito'
    expect(page).to have_content 'Quantidade máxima de parcelas: 1x'
    expect(page).to have_content 'Desconto à vista: 5%'
    expect(page).to have_content 'Usuário responsável: Paola | paola@sistemadefraude.com.br'
  end

  it 'e não preenche os dados corretamente' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    first_pay_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
    payment_option = FactoryBot.create(
      :company_payment_option,
      user:,
      insurance_company: company,
      payment_method: first_pay_method,
      max_parcels: 12,
      single_parcel_discount: 0
    )

    login_as user, scope: :user
    visit edit_company_payment_option_path(payment_option)

    fill_in 'Quantidade máxima de parcelas', with: ''
    fill_in 'Desconto à vista', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento não foi editada'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Quantidade máxima de parcelas não pode ficar em branco'
    expect(page).to have_content 'Desconto à vista não pode ficar em branco'
  end

  it 'e edita uma opção que outro usuário criou' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(
      :user, insurance_company_id: company.id,
             name: 'Bruna', email: 'bruna@sistemadefraude.com.br'
    )
    other_user = FactoryBot.create(
      :user, insurance_company_id: company.id,
             name: 'Paola Trambiqueira', email: 'paola@paola.com.br'
    )
    first_pay_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
    payment_option = FactoryBot.create(
      :company_payment_option,
      user:,
      insurance_company: company,
      payment_method: first_pay_method,
      max_parcels: 12,
      single_parcel_discount: 0
    )

    login_as other_user, scope: :user
    visit edit_company_payment_option_path(payment_option)
    fill_in 'Quantidade máxima de parcelas', with: '4'
    fill_in 'Desconto à vista', with: '1'
    click_on 'Enviar'

    expect(page).to have_content 'Opção de pagamento editada com sucesso'
    expect(page).to have_content 'Opção de Pagamento: Cartão Nubank'
    expect(page).to have_content 'Tipo de Pagamento: Cartão de Crédito'
    expect(page).to have_content 'Quantidade máxima de parcelas: 4x'
    expect(page).to have_content 'Desconto à vista: 1%'
    expect(page).to have_content 'Usuário responsável: Paola Trambiqueira | paola@paola.com.br'
  end
end
