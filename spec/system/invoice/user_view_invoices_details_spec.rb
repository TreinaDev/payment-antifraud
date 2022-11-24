require 'rails_helper'

describe 'Usuário vê detalhes de uma cobranças' do
  it 'com sucesso' do
    allow(SecureRandom).to receive(:alphanumeric).and_return('AGBS65OFN493OE93MVNA')
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method, name: 'Laranja', payment_type: 'Cartão de Crédito')
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 2,
                               registration_number: '12345678', status: :pending, voucher: 'Black123',
                               parcels: 10, total_price: 20.0)
    insurance = File.read 'spec/support/json/insurance.json'
    fake_response1 = double('Faraday::Response', status: 200, body: insurance)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/#{invoice.insurance_company_id}")
      .and_return(fake_response1)
    package = File.read 'spec/support/json/package_id.json'
    fake_response2 = double('Faraday::Response', status: 200, body: package)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/packages/#{invoice.package_id}")
      .and_return(fake_response2)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Cobranças'
    within 'article main' do
      click_on 'Ver mais'
    end

    expect(current_path).to eq invoice_path(invoice.id)
    expect(page).to have_content 'Status: pendente'
    expect(page).to have_content 'AGBS65OFN493OE93MVNA'
    expect(page).to have_content 'Seguradora: Liga de Seguros'
    expect(page).to have_content 'Pacote de Seguros: Super Econômico'
    expect(page).to have_content 'Meio de Pagamento: Laranja'
    expect(page).to have_content 'Tipo de Pagamento: Cartão de Crédito'
    expect(page).to have_content "Cupom: Black123"
    expect(page).to have_content 'Parcelas: 10'
    expect(page).to have_content 'Preço Total: R$ 20,00'
  end

  it 'e não vê transaction_registration_numbe e reason' do
    allow(SecureRandom).to receive(:alphanumeric).and_return('AGBS65OFN493OE93MVNA')
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, status: 'approved', insurance_company: company)
    insurance = File.read 'spec/support/json/insurance.json'
    fake_response1 = double('Faraday::Response', status: 200, body: insurance)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/#{invoice.insurance_company_id}")
      .and_return(fake_response1)
    package = File.read 'spec/support/json/package_id.json'
    fake_response2 = double('Faraday::Response', status: 200, body: package)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/packages/#{invoice.package_id}")
      .and_return(fake_response2)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Cobranças'
    within 'article main' do
      click_on 'Ver mais'
    end

    expect(current_path).to eq invoice_path(invoice.id)
    expect(page).not_to have_content 'Motivo da falha'
    expect(page).to have_content 'Número de registro da transação'
  end
end
