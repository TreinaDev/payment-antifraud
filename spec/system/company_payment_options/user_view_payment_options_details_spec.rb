require 'rails_helper'

describe 'Usuário vê detalhes de uma opção de pagamento da sua seguradora' do
  it 'a partir da tela de opções de pagamento' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id,
                               name: 'Bruna de Paula', email: 'bruna@paolaseguros.com.br')
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
    visit company_payment_options_path
    click_on 'Cartão Nubank'

    expect(page).to have_content 'Detalhes da opção de pagamento'
    expect(page).to have_content 'Opção de Pagamento: Cartão Nubank'
    expect(page).to have_content 'Tipo de Pagamento: Cartão de Crédito'
    expect(page).to have_content 'Quantidade máxima de parcelas: 12x'
    expect(page).to have_content 'Desconto à vista: Não Possui'
    expect(page).to have_content 'Usuário responsável: Bruna de Paula | bruna@paolaseguros.com.br'
  end

  it 'e vê detalhes de uma opção que outro usuário cadastrou' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id,
                               name: 'Bruna de Paula', email: 'bruna@paolaseguros.com.br')
    other_user = FactoryBot.create(:user, insurance_company_id: company.id,
                                     name: 'Paolitas Paolinha', email: 'paola@paolaseguros.com.br')
    payment_method = FactoryBot.create(:payment_method, name: 'Boleto', payment_type: 'Boleto')
    payment_option = FactoryBot.create(
      :company_payment_option,
      user: other_user,
      insurance_company: company,
      payment_method:,
      max_parcels: 5,
      single_parcel_discount: 1
    )

    login_as user, scope: :user
    visit company_payment_option_path(payment_option.id)

    expect(page).to have_content 'Opção de Pagamento: Boleto'
    expect(page).to have_content 'Tipo de Pagamento: Boleto'
    expect(page).to have_content 'Quantidade máxima de parcelas: 5x'
    expect(page).to have_content 'Desconto à vista: 1%'
    expect(page).to have_content 'Usuário responsável: Paolitas Paolinha | paola@paolaseguros.com.br'
  end
end
