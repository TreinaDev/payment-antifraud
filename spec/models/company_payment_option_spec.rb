require 'rails_helper'

RSpec.describe CompanyPaymentOption, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'Falso quando payment_method está em branco' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method: nil,
          user:,
          insurance_company: company,
          max_parcels: 0,
          single_parcel_discount: 0
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:payment_method)).to eq true
      end

      it 'Falso quando max_parcels está em branco' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_method = FactoryBot.create(:payment_method)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user:,
          insurance_company: company,
          max_parcels: nil,
          single_parcel_discount: 0
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:max_parcels)).to eq true
      end

      it 'Falso quando single_parcel_discount está em branco' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_method = FactoryBot.create(:payment_method)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user:,
          insurance_company: company,
          max_parcels: 0,
          single_parcel_discount: nil
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:single_parcel_discount)).to eq true
      end

      it 'Falso quando user está em branco' do
        company = FactoryBot.create(:insurance_company)
        payment_method = FactoryBot.create(:payment_method)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user: nil,
          insurance_company: company,
          max_parcels: nil,
          single_parcel_discount: 0
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:user)).to eq true
      end

      it 'Falso quando company está em branco' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_method = FactoryBot.create(:payment_method)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user:,
          insurance_company: nil,
          max_parcels: nil,
          single_parcel_discount: 0
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:insurance_company)).to eq true
      end
    end

    context 'numericality' do
      it 'Falso quando max_parcels é preenchido com 0' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_method = FactoryBot.create(:payment_method)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user:,
          insurance_company: company,
          max_parcels: 0,
          single_parcel_discount: 0
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:max_parcels)).to eq true
      end

      it 'Falso quando max_parcels é preenchido com um número negativo' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_method = FactoryBot.create(:payment_method)
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user:,
          insurance_company: company,
          max_parcels: -999,
          single_parcel_discount: 0
        )

        payment_option.save

        expect(payment_option).not_to be_valid
        expect(payment_option.errors.include?(:max_parcels)).to eq true
      end
    end

    context '.check_if_payment_type_can_be_parceled' do
      it 'Impede a criação do objeto se pagamento que não pode ser parcelado estiver com mais de 1 parcela' do
        company = FactoryBot.create(:insurance_company)
        user = FactoryBot.create(:user, insurance_company_id: company.id)
        payment_method = FactoryBot.create(:payment_method, payment_type: 'Pix')
        payment_option = FactoryBot.build(
          :company_payment_option,
          payment_method:,
          user:,
          insurance_company: company,
          max_parcels: 25,
          single_parcel_discount: 0
        )

        expect(payment_option.save).to be_falsy
      end
    end
  end
end
