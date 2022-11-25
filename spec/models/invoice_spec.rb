require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it 'Gera um código aleatório' do
    payment_method = create(:payment_method)
    insurance_company = create(:insurance_company)
    user = create(:user, insurance_company:)
    create(:company_payment_option, user:,
                                    insurance_company:,
                                    payment_method:,
                                    max_parcels: 10,
                                    single_parcel_discount: 5)
    invoice = build(:invoice, payment_method_id: payment_method.id, insurance_company_id: insurance_company.id)

    invoice.save!
    result = invoice.token

    expect(result).not_to be_empty
    expect(result.length).to eq 20
  end

  it 'o código é único' do
    payment_method = create(:payment_method)
    insurance_company = create(:insurance_company)
    user = create(:user, insurance_company:)
    create(:company_payment_option, user:,
                                    insurance_company:,
                                    payment_method:,
                                    max_parcels: 10,
                                    single_parcel_discount: 5)
    invoice_a = create(:invoice, payment_method_id: payment_method.id, insurance_company_id: insurance_company.id)
    invoice_b = create(:invoice, payment_method_id: payment_method.id, insurance_company_id: insurance_company.id)

    result = invoice_a.token
    expect(invoice_b.token).not_to eq result
  end

  context '#valid?' do
    it 'com meio de pagamento não escolhido pela seguradora' do
      payment_method1 = create(:payment_method, name: 'Laranja',
                                                tax_percentage: 5, tax_maximum: 100,
                                                payment_type: 'Cartão de Crédito',
                                                status: :active)
      insurance_company = create(:insurance_company)
      user = create(:user, insurance_company:)
      create(:company_payment_option, user:,
                                      insurance_company:,
                                      payment_method: payment_method1,
                                      max_parcels: 10,
                                      single_parcel_discount: 5)
      payment_method2 = create(:payment_method, name: 'Amarelo',
                                                tax_percentage: 10, tax_maximum: 80,
                                                payment_type: 'Boleto',
                                                status: :active)
      invoice = build(:invoice, payment_method: payment_method2, insurance_company:)

      expect(invoice.valid?).to be false
    end

    it 'numero de registro da transação é obrigatório se status for sucesso no pagamento' do
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      payment_method = create(:payment_method)
      FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                                 payment_method_id: payment_method.id, user:)
      invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                                 registration_number: '12345678998', status: :pending, voucher: 'Black123')

      invoice.update(status: :approved)

      expect(invoice.errors.include?(:transaction_registration_number)).to eq true
      expect(invoice.errors.include?(:reason_for_failure)).to eq false
    end

    it 'motivo da falha é obrigatório se status for falha no pagamento' do
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      payment_method = create(:payment_method)
      FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                                 payment_method_id: payment_method.id, user:)
      invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                                 registration_number: '12345678998', status: :pending, voucher: 'Black123')

      invoice.update(status: :refused)

      expect(invoice.errors.include?(:reason_for_failure)).to eq true
      expect(invoice.errors.include?(:transaction_registration_number)).to eq false
    end

    it 'sendo order_id obrigatórios' do
      invoice = build(:invoice, order_id: nil)

      invoice.valid?
      expect(invoice.errors.include?(:order_id)).to eq true
    end

    it 'sendo package_id obrigatórios' do
      invoice = build(:invoice, package_id: nil)

      invoice.valid?
      expect(invoice.errors.include?(:package_id)).to eq true
    end

    it 'sendo total_price obrigatórios' do
      invoice = build(:invoice, total_price: nil)

      invoice.valid?
      expect(invoice.errors.include?(:total_price)).to eq true
    end

    it 'sendo registration_number obrigatórios' do
      invoice = build(:invoice, registration_number: nil)

      invoice.valid?
      expect(invoice.errors.include?(:registration_number)).to eq true
    end

    it 'sendo parcels obrigatórios' do
      invoice = build(:invoice, parcels: nil)

      invoice.valid?
      expect(invoice.errors.include?(:parcels)).to eq true
    end
  end

  context '#numericality' do
    it 'falso quando parcels é zero' do
      invoice = build(:invoice, parcels: 0)

      invoice.valid?
      expect(invoice.errors.include?(:parcels)).to eq true
    end

    it 'falso quando total_price é zero' do
      invoice = build(:invoice, total_price: 0)

      invoice.valid?
      expect(invoice.errors.include?(:total_price)).to eq true
    end

    it 'falso quando parcels não é integer' do
      invoice = build(:invoice, parcels: '0')

      invoice.valid?
      expect(invoice.errors.include?(:parcels)).to eq true
    end
    it 'falso se registratiton_number for maior que 11' do
      invoice = build(:invoice, registration_number: '12345678998212121')

      invoice.valid?
      expect(invoice.errors.include?(:registration_number)).to eq true
    end
  end

  it 'Método devolve nome da companhia de seguro' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 2,
                               registration_number: '12345678998', status: :pending, voucher: 'Black123',
                               parcels: 10, total_price: 20.0)
    insurance = File.read 'spec/support/json/insurance.json'
    fake_response = double('Faraday::Response', status: 200, body: insurance)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/#{invoice.insurance_company_id}")
      .and_return(fake_response)

    expect(invoice.insurance_company_name).to eq 'Liga de Seguros'
  end

  it 'Método devolve array vazio quando recebe um status 204(No Content) da API' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 2,
                               registration_number: '12345678998', status: :pending, voucher: 'Black123',
                               parcels: 10, total_price: 20.0)
    fake_response = double('Faraday::Response', status: 204, body: {})
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/#{invoice.insurance_company_id}")
      .and_return(fake_response)

    expect(invoice.insurance_company_name).to eq []
  end

  it 'Método devolve nome do pacote de seguro' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 2,
                               registration_number: '12345678998', status: :pending, voucher: 'Black123',
                               parcels: 10, total_price: 20.0)
    package = File.read 'spec/support/json/package_id.json'
    fake_response = double('Faraday::Response', status: 200, body: package)
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/packages/#{invoice.package_id}")
      .and_return(fake_response)

    expect(invoice.package_name).to eq 'Super Econômico'
  end

  it 'Método devolve array vazio quando recebe um status 204(No Content) da API' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 2,
                               registration_number: '12345678998', status: :pending, voucher: 'Black123',
                               parcels: 10, total_price: 20.0)
    fake_response = double('Faraday::Response', status: 204, body: {})
    allow(Faraday).to receive(:get)
      .with("#{Rails.configuration.external_apis['insurance_api']}/packages/#{invoice.package_id}")
      .and_return(fake_response)

    expect(invoice.package_name).to eq []
  end
end
