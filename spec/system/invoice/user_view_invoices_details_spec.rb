require 'rails_helper'

describe 'Usuário vê detalhes de uma cobranças' do
  it 'com sucesso' do
    allow(SecureRandom).to receive(:alphanumeric).and_return('AGBS65OFN493OE93MVNA')
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    invoice = create(:invoice, payment_method: payment_method , insurance_company_id: 5, package_id: 10,
                               registration_number: '12345678', status: :pending)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Cobranças'
    within('table') do
      click_on 'Ver mais'
    end

    expect(current_path).to eq invoice_path(invoice.id)
    expect(page).to have_content 'Status: pendente'
    expect(page).to have_content 'AGBS65OFN493OE93MVNA'
    expect(page).to have_content 'ID Seguradora: 5'
    expect(page).to have_content 'ID Pacote de Seguros: 10'
    expect(page).to have_content 'Meio de Pagamento:'
    expect(page).to have_content 'Tipo de Pagamento:'
  end
end
