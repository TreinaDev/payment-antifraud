require 'rails_helper'

describe 'Usuário vê detalhes de uma denúncia de fraude' do 
  it 'caso seja da sua seguradora' do 
    user_company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    other_company = FactoryBot.create(:insurance_company, external_insurance_company: 99)
    user = FactoryBot.create(:user, insurance_company_id: user_company.id)
    other_company_fraud = FactoryBot.create(:fraud_report, insurance_company_id: other_company.id)

    login_as user, scope: :user 
    visit fraud_report_path(other_company_fraud)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso negado.'
  end
end