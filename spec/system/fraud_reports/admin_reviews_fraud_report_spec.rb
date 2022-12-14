require 'rails_helper'

describe 'Admin avalia uma denúncia de fraude' do
  it 'a partir da tela de detalhes, e a aprova' do
    company = create(:insurance_company)
    admin = create(:admin)
    fraud_report = create(
      :fraud_report, registration_number: '12345678911',
                     insurance_company_id: company.id, description: 'Tentou fraudar o seguro.',
                     status: :pending
    )

    login_as admin, scope: :admin
    visit root_path
    click_on 'Denúncias de fraude'
    click_on 'Ver detalhes'
    click_on 'Aprovar'
    blocked_cpf = BlockedRegistrationNumber.last

    expect(page).not_to have_button 'Aprovar'
    expect(page).not_to have_button 'Reprovar'
    expect(page).to have_content 'Denúncia aprovada com sucesso.'
    expect(page).to have_content 'Denúncia do CPF: 123.456.789-11'
    expect(page).to have_content 'Descrição: Tentou fraudar o seguro.'
    expect(page).to have_content 'Status: Aprovada'
    expect(blocked_cpf.registration_number).to eq fraud_report.registration_number
  end

  it 'a partir da tela de detalhes, e a reprova' do
    company = create(:insurance_company)
    admin = create(:admin)
    fraud = create(
      :fraud_report, registration_number: '45687912399',
                     insurance_company_id: company.id, description: 'Possível tentativa de fraudar o seguro.',
                     status: :pending
    )

    login_as admin, scope: :admin
    visit fraud_report_path(fraud.id)
    click_on 'Reprovar'

    expect(page).not_to have_button 'Aprovar'
    expect(page).not_to have_button 'Reprovar'
    expect(page).to have_content 'Denúncia reprovada com sucesso.'
    expect(page).to have_content 'Denúncia do CPF: 456.879.123-99'
    expect(page).to have_content 'Descrição: Possível tentativa de fraudar o seguro.'
    expect(page).to have_content 'Status: Não comprovada'
  end

  it 'a partir da tela de detalhes, e a aprova uma denuncia contra um cpf que já está na lista de bloqueio' do
    company = create(:insurance_company)
    admin = create(:admin)
    create(:blocked_registration_number, registration_number: '12345678911')
    fraud_report = create(
      :fraud_report, registration_number: '12345678911',
                     insurance_company_id: company.id, description: 'Tentou fraudar o seguro.',
                     status: :pending
    )

    login_as admin, scope: :admin
    visit root_path
    click_on 'Denúncias de fraude'
    click_on 'Ver detalhes'
    click_on 'Aprovar'
    blocked_cpf = BlockedRegistrationNumber.last

    expect(page).not_to have_button 'Aprovar'
    expect(page).not_to have_button 'Reprovar'
    expect(page).to have_content 'Denúncia aprovada com sucesso.'
    expect(page).to have_content 'Denúncia do CPF: 123.456.789-11'
    expect(page).to have_content 'Descrição: Tentou fraudar o seguro.'
    expect(page).to have_content 'Status: Aprovada'
    expect(blocked_cpf.registration_number).to eq fraud_report.registration_number
  end
end
