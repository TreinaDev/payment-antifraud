require 'rails_helper'

describe 'Usuário altera status de uma cobrança' do
  it 'a partir da tela de detalhes' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678987', status: :pending, voucher: 'Black123')
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
    click_on 'Ver mais'

    expect(page).to have_link 'Sucesso no Pagamento'
    expect(page).to have_link 'Falha no Pagamento'
  end

  it 'e vai para formulário de informações adicionais' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678987', status: :pending, voucher: 'Black123')
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
    visit invoice_url(invoice.id)
    click_on 'Sucesso no Pagamento'

    expect(page).to have_content 'Atualizar pagamento da cobrança'
    expect(page).to have_field 'Número de registro da transação'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso para Sucesso no Pagamento' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678987', status: :pending, voucher: 'Black123')
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
    json_data = Rails.root.join('spec/support/json/approved_invoice.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Sucesso no Pagamento'
    fill_in 'Número de registro da transação', with: '12345678901'
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança atualizada com sucesso'
    expect(page).to have_content 'Status: aprovado'
    expect(page).to have_content 'Número de registro da transação: 12345678901'
    expect(page).not_to have_link 'Sucesso no Pagamento'
    expect(page).not_to have_link 'Falha no Pagamento'
  end

  it 'com sucesso para Falha no Pagamento' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678987', status: :pending, voucher: 'Black123')
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
    json_data = Rails.root.join('spec/support/json/refused_invoice.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Falha no Pagamento'
    fill_in 'Motivo da falha', with: 'Transação negada pela bandeira'
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança atualizada com sucesso'
    expect(page).to have_content 'Status: recusado'
    expect(page).to have_content 'Motivo da falha: Transação negada pela bandeira'
    expect(page).not_to have_link 'Sucesso no Pagamento'
    expect(page).not_to have_link 'Falha no Pagamento'
  end

  it 'para Falha no Pagamento com informações incompletas' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678987', status: :pending, voucher: 'Black123')
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
    visit invoice_url(invoice.id)
    click_on 'Falha no Pagamento'
    fill_in 'Motivo da falha', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança não foi atualizada'
    expect(page).to have_content 'Motivo da falha não pode ficar em branco'
    expect(page).not_to have_content 'Número de registro da transação não pode ficar em branco'
  end

  it 'para Sucesso no Pagamento com informações incompletas' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678987', status: :pending, voucher: 'Black123')
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
    visit invoice_url(invoice.id)
    click_on 'Sucesso no Pagamento'
    fill_in 'Número de registro da transação', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança não foi atualizada'
    expect(page).not_to have_content 'Motivo da falha não pode ficar em branco'
    expect(page).to have_content 'Número de registro da transação não pode ficar em branco'
  end
end
