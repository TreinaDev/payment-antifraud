require 'rails_helper'

describe 'Funcionário registra nova denúncia de fraude' do
  it 'se estiver autenticado como funcionário' do 
    admin = FactoryBot.create(:admin)

    login_as admin, scope: :admin
    visit new_fraud_report_path

    expect(page).to have_content 'Acesso negado.'
  end
  
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
    expect(page).to have_field 'Imagens'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do 
    company = FactoryBot.create(:insurance_company, external_insurance_company: 10)
    user = FactoryBot.create(:user, insurance_company_id: company.id)

    login_as user, scope: :user 
    visit new_fraud_report_path

    fill_in 'CPF', with: '12345678911'
    fill_in 'Descrição', with: 'Ela é vigarista, trapaceira, que se aproveita'
    attach_file 'Imagens', [Rails.root.join('spec/support/crime.jpeg'), Rails.root.join('spec/support/fotos_do_crime.jpeg')]
    click_on 'Enviar'

    expect(page).to have_content 'Denúncia enviada com sucesso.'
    expect(page).to have_content 'Denúncia do CPF: 123.456.789-11'
    expect(page).to have_content 'Descrição: Ela é vigarista, trapaceira, que se aproveita'
    expect(page).to have_css('img[src*="crime.jpeg"]')
    expect(page).to have_css('img[src*="fotos_do_crime.jpeg"]')
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
