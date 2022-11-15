require 'rails_helper'

describe 'Usuário vê cobranças' do
  it 'e não está autenticado' do
    company = FactoryBot.create(:insurance_company)
    payment_method = create(:payment_method)
    create(:invoice, payment_method:, insurance_company_id: company.id)
    FactoryBot.create(:user, insurance_company_id: company.id)

    visit root_path
    click_on 'Cobranças'

    expect(current_url).to eq root_url
    expect(page).to have_content 'Acesso negado'
  end

  it 'com sucesso' do
    allow(SecureRandom).to receive(:alphanumeric).and_return('AGBS65OFN493OE93MVNA')
    company = FactoryBot.create(:insurance_company)
    payment_method = create(:payment_method)
    create(:invoice, payment_method:, insurance_company_id: company.id)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                     registration_number: '12345678', status: :pending)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Cobranças'

    expect(current_path).to eq invoices_path
    expect(page).to have_content 'Token'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'AGBS65OFN493OE93MVNA'
    expect(page).to have_content 'ID Pacote de Seguros'
    expect(page).to have_content '10'
    expect(page).to have_content 'pendente'
  end

  it 'somente de sua seguradora' do
    company1 = FactoryBot.create(:insurance_company, external_insurance_company: 1)
    FactoryBot.create(:user, insurance_company_id: company1.id)
    payment_method = FactoryBot.create(:payment_method)
    allow(SecureRandom).to receive(:alphanumeric).and_return('AAAS65OFN493OE93MVNA')
    FactoryBot.create(:invoice, payment_method:, insurance_company_id: company1.id, package_id: 10,
                                registration_number: '12345678', status: :pending, order_id: 1)
    company2 = FactoryBot.create(:insurance_company, external_insurance_company: 1)
    user2 = FactoryBot.create(:user, insurance_company_id: company2.id)
    allow(SecureRandom).to receive(:alphanumeric).and_return('BBBS65OFN493OE93MVNA')
    create(:invoice, payment_method:, insurance_company_id: company2.id, package_id: 5,
                     registration_number: '12345678', status: :payd, order_id: 2)

    login_as(user2, scope: :user)
    visit root_path
    click_on 'Cobranças'

    expect(current_path).to eq invoices_path
    expect(page).to have_content 'BBBS65OFN493OE93MVNA'
    expect(page).to have_content '5'
    expect(page).to have_content 'Paga'
    expect(page).not_to have_content 'AAAS65OFN493OE93MVNA'
    expect(page).not_to have_content '10'
    expect(page).not_to have_content 'pendente'
  end
end
