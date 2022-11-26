require 'rails_helper'

describe 'Usuário remove opção de pagamento configurada' do
  it 'com sucesso' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id,
                         name: 'Bruna de Paula', email: 'bruna@paolaseguros.com.br')
    payment_method = create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
    create(
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
    click_on 'Remover'

    expect(current_url).to eq company_payment_options_url
    expect(page).to have_content 'Opção de pagamento removida com sucesso.'
    expect(page).not_to have_content '12x'
    expect(page).not_to have_content 'Não Possui'
  end
end
