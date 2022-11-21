require 'rails_helper'

describe 'Administrador visita página de fraudes' do
  it 'se estiver autenticado' do
    visit fraud_reports_path

    expect(page).to have_content 'Acesso negado.'
  end

  it 'e vê as fraudes cadastradas de todas as seguradoras' do
    admin = FactoryBot.create(:admin)
    company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    other_company = FactoryBot.create(:insurance_company, external_insurance_company: 3)
    FactoryBot.create(:fraud_report, registration_number: 34_568_743_291,
                                     insurance_company_id: company.id)
    FactoryBot.create(:fraud_report, registration_number: 42_312_346_578,
                                     insurance_company_id: other_company.id)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Denúncias de fraude'

    expect(page).to have_content 'Denúncias de fraude'
    expect(page).to have_content 'CPF'
    expect(page).to have_content '345.687.432-91'
    expect(page).to have_content '423.123.465-78'
    expect(page).to have_link 'Ver detalhes'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Pendente'
  end

  it 'e não há denúncias cadastradas.' do
    admin = FactoryBot.create(:admin)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Denúncias de fraude'

    expect(page).to have_content 'Não há denúncias de fraude registradas.'
  end
end
