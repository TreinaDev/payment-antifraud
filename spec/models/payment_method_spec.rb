require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe '#valid?' do
    context 'atributo obrigatório' do
      it 'nome é obrigatório' do
        payment_method = PaymentMethod.new(name: '')
        payment_method.valid?

        expect(payment_method.errors.include?(:name)).to eq true
      end

      it 'Taxa por Cobrança é obrigatório' do
        payment_method = PaymentMethod.new(tax_percentage: '')
        payment_method.valid?

        expect(payment_method.errors.include?(:tax_percentage)).to eq true
      end

      it 'Taxa Máxima é obrigatório' do
        payment_method = PaymentMethod.new(tax_maximum: '')
        payment_method.valid?

        expect(payment_method.errors.include?(:tax_maximum)).to eq true
      end

      it 'Tipo de pagamento é obrigatório' do
        payment_method = PaymentMethod.new(payment_type: '')
        payment_method.valid?

        expect(payment_method.errors.include?(:payment_type)).to eq true
      end

      it 'Tipo de pagamento é obrigatório' do
        payment_method = PaymentMethod.new(payment_type: '')
        payment_method.valid?

        expect(payment_method.errors.include?(:payment_type)).to eq true
      end
    end

    context 'atributo postivo' do
      it 'Taxa por Cobrança é positivo' do
        payment_method = PaymentMethod.new(tax_percentage: -10)
        payment_method.valid?

        expect(payment_method.errors.include?(:tax_percentage)).to eq true
      end

      it 'Taxa Máxima é positivo' do
        payment_method = PaymentMethod.new(tax_maximum: -10)
        payment_method.valid?

        expect(payment_method.errors.include?(:tax_maximum)).to eq true
      end
    end
  end
end
