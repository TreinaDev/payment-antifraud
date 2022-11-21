require 'rails_helper'

describe 'Usuário vê suas denúncias de fraude' do
  it 'e vê as denúncias da sua seguradora' do
    company = FactoryBot.create(:insurance_company, external_insurance_company: 98)
    other_company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    FactoryBot.create(:fraud_report, registration_number: 34_568_743_291,
                                     insurance_company_id: company.id)
    FactoryBot.create(:fraud_report, registration_number: 42_312_346_578,
                                     insurance_company_id: other_company.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Denúncias de fraude'

    expect(page).to have_content 'Denúncias de fraude'
    expect(page).to have_content 'CPF'
    expect(page).to have_content '345.687.432-91'
    expect(page).not_to have_content '423.123.465-78'
    expect(page).to have_link 'Ver detalhes'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Pendente'
  end
end