require 'rails_helper'

describe 'Funcionário registra nova denúncia de fraude' do
  it 'a partir de um formulário' do
    company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user 
    visit fraud_reports_path
    click_on 'Fazer uma denúncia'

    expect(current_path).to eq new_fraud_report_path
    expect(page).to have_content 'Nova denúncia'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'CPF'
    expect(page).to have_content 'Adicione imagens para comprovar a fraude:'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do 
    
  end

  it 'com dados incompletos' do
    company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user 
    visit fraud_reports_path
    click_on 'Fazer uma denúncia'
    fill_in 'Descrição', with: ''
    fill_in 'CPF', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Denúncia NÃO cadastrada!'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Imagens não pode ficar em branco'
    expect(page).to have_content 'São necessárias, no mínimo, duas imagens para comprovação.'
  end
end

#attach_file 'Provas', Rails.root.join('spec/support/crime.jpeg')
#attach_file 'Provas', Rails.root.join('spec/support/fotos_do_crime.jpeg')
