require 'rails_helper'

describe 'Usuário vê suas denúncias de fraude' do
  it 'e vê as denúncias da sua seguradora' do
    company = create(:insurance_company, external_insurance_company: 98)
    other_company = create(:insurance_company, external_insurance_company: 10)
    user = create(:user, insurance_company_id: company.id)
    create(:fraud_report, registration_number: 34_568_743_291,
                                     insurance_company_id: company.id)
    create(:fraud_report, registration_number: 42_312_346_578,
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
    within 'article footer #pagination' do
      expect(page).to have_content 'Primeira'
      expect(page).to have_content '< Anterior'
      expect(page).to have_content 'Página 1 de 1'
      expect(page).to have_content 'Próxima >'
      expect(page).to have_content 'Última'
    end
  end
end
