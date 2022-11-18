require 'rails_helper'

describe 'Funcionário registra nova denúncia de fraude' do
  it 'com sucesso' do
    company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user 
    visit fraud_reports_path
    click_on 'Fazer uma denúncia'

    expect(current_path).to eq new_fraud_report_path
    expect(page).to have_content 'Nova denúncia.'
    expect(page).to have_field 'Descrição:'
    expect(page).to have_field 'CPF:'
    expect(page).to have_content 'Adicione imagens para comprovar a fraude:'
    expect(page).to have_button 'Enviar'
  end
end
