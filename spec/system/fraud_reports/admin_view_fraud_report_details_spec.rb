require 'rails_helper'

describe 'Administrador vê detalhes de uma denúncia de fraude' do
  it 'com sucesso' do
    company = create(:insurance_company, external_insurance_company: 10)
    admin = create(:admin)
    fraud = create(
      :fraud_report, insurance_company_id: company.id,
                     registration_number: '12345678911', description: 'É CALOTEIRO',
                     status: :pending
    )

    login_as admin, scope: :admin
    visit root_path
    click_on 'Denúncias de fraude'
    click_on 'Ver detalhes'

    expect(current_path).to eq fraud_report_path(fraud.id)
    expect(page).to have_content 'Denúncia do CPF: 123.456.789-11'
    expect(page).to have_content 'Descrição: É CALOTEIRO'
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_button 'Aprovar'
    expect(page).to have_button 'Reprovar'
  end
end
