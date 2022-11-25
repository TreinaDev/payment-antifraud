require 'rails_helper'

describe 'API Cobranças' do
  it 'POST api/v1/invoices' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(
      :company_payment_option,
      user:,
      insurance_company: company,
      payment_method:,
      max_parcels: 12,
      single_parcel_discount: 0
    )
    params = { invoice: { total_price: 50, package_id: 1, registration_number: '12345678987',
                          insurance_company_id: company.id,
                          order_id: 1, payment_method_id: payment_method.id, voucher: 'CAMPUS20', parcels: 10 } }
    post api_v1_invoices_path, params: params

    expect(Invoice.count).to eq 1
    expect(Invoice.last.package_id).to eq(1)
    expect(Invoice.last.registration_number).to eq('12345678987')
    expect(Invoice.last.insurance_company_id).to eq(1)
    expect(Invoice.last.order_id).to eq(1)
  end
  it 'POST api/v1/invoices errors' do
    company = create(:insurance_company)
    user = create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(
      :company_payment_option,
      user:,
      insurance_company: company,
      payment_method:,
      max_parcels: 12,
      single_parcel_discount: 0
    )
    params = { invoice: { total_price: 50, package_id: 1, registration_number: '12345678987',
                          insurance_company_id: 999,
                          order_id: 1, payment_method_id: payment_method.id, voucher: 'CAMPUS20', parcels: 10 } }
    post api_v1_invoices_path, params: params

    expect(Invoice.count).to eq 0
    expect(response.status).to eq 412
  end
end
