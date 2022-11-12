require 'rails_helper'

describe 'Usuário vê os meios de pagamentos associados a sua companhia' do 
  it 'a partir da tela da sua seguradora' do 
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    first_payment_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank')
    second_payment_method = FactoryBot.create(:payment_method, name: 'Boleto')
    FactoryBot.create(
                      :company_payment_option,
                      user: user, 
                      insurance_company: company,
                      payment_method: first_payment_method,
                      max_parcels: 12,
                      single_parcel_discount: 0
                    )
    FactoryBot.create(
                      :company_payment_option,
                      user: user, 
                      insurance_company: company,
                      payment_method: second_payment_method,
                      max_parcels: 1,
                      single_parcel_discount: 2
                    )
    
    login_as user, scope: :user 
    visit root_path 
    click_on 'Minha Seguradora'

    expect(page).to have_content 'Opções de Pagamento'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Cartão Nubank'
    expect(page).to have_content 'Boleto'
    expect(page).to have_content 'Qtd. Máx. Parcelas'
    expect(page).to have_content '12x'
    expect(page).to have_content '1x'
    expect(page).to have_content 'Desconto à vista'
    expect(page).to have_content 'Não Possui'
    expect(page).to have_content '2%'
  end

  it 'e ainda não há meios de pagamento configurados' do 
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    
    login_as user, scope: :user 
    visit root_path 
    click_on 'Minha Seguradora'

    expect(page).to have_content 'Ainda não há opções de pagamento configuradas para esta seguradora'
    expect(page).not_to have_content 'Nome'
    expect(page).not_to have_content 'Qtd. Máx. Parcelas'
    expect(page).not_to have_content 'Desconto à vista'
  end
end