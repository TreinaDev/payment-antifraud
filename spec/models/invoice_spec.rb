require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Gera um código aleatório' do
    it 'ao criar um uma cobrança' do
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

    it 'e o código é único' do
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
  end

  describe '#valid?' do
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
                                 registration_number: '12345678', status: :pending, voucher: 'Black123')

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
                                 registration_number: '12345678', status: :pending, voucher: 'Black123')

      invoice.update(status: :refused)

      expect(invoice.errors.include?(:reason_for_failure)).to eq true
      expect(invoice.errors.include?(:transaction_registration_number)).to eq false
    end
  end
end
