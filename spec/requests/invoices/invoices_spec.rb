require 'rails_helper'

describe 'POST#edit comparator/api/v1/invoices/id' do
  it 'aprovação do status de uma cobrança' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')
    json_data = Rails.root.join('spec/support/json/refused_invoice.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as(user, scope: :user)
    patch invoice_path(invoice),
          params: { invoice: { status: :approved, transaction_registration_number: 'AHDSU1923' } }

    expect(response).to redirect_to(invoice_path(invoice))
  end

  it 'reprovação do status de uma cobrança' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')
    json_data = Rails.root.join('spec/support/json/refused_invoice.json').read
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as(user, scope: :user)
    patch invoice_path(invoice), params: { invoice: { status: :refused, reason_for_failure: 'Cartão Recusado' } }

    expect(response).to redirect_to(invoice_path(invoice))
  end

  it 'e acontece um erro interno' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')
    allow(Faraday).to receive(:post).and_raise(ActiveRecord::QueryCanceled)

    login_as(user, scope: :user)
    patch invoice_path(invoice), params: { invoice: { status: :refused, reason_for_failure: 'Cartão Recusado' } }

    response { should render_template(:edit) }
    expect(invoice.reload.status).to eq 'pending'
  end

  it 'e encontra registro vazio (204)' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')
    fake_response = double('Faraday::Response', status: 204, body: [])
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as(user, scope: :user)
    patch invoice_path(invoice), params: { invoice: { status: :refused, reason_for_failure: 'Cartão Recusado' } }

    response { should render_template(:edit) }
    expect(invoice.reload.status).to eq 'pending'
  end
end
