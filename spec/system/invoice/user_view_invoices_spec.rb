require 'rails_helper'

describe 'Usuário vê cobranças' do
  it 'e não está autenticado' do
    company = FactoryBot.create(:insurance_company)
    FactoryBot.create(:user, insurance_company_id: company.id)

    visit root_path
    click_on 'Cobranças'

    expect(current_url).to eq root_url
    expect(page).to have_content 'Acesso negado'
  end

  it 'com sucesso' do
    allow(SecureRandom).to receive(:alphanumeric).and_return('AGBS65OFN493OE93MVNA')
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    create(:invoice, insurance_company_id: 5, package_id: 10,
                     registration_number: '12345678', status: :pending)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Cobranças'

    expect(current_path).to eq invoices_path
    expect(page).to have_content 'Token'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'AGBS65OFN493OE93MVNA'
    expect(page).to have_content 'ID Seguradora'
    expect(page).to have_content 'ID Pacote de Seguros'
    expect(page).to have_content '5'
    expect(page).to have_content '10'
    expect(page).to have_content 'pendente'
  end
end
