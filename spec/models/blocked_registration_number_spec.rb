require 'rails_helper'

RSpec.describe BlockedRegistrationNumber, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'falso quando CPF é registrado em branco' do
        registry = FactoryBot.build(:blocked_registration_number, registration_number: '')

        registry.save

        expect(registry).not_to be_valid
        expect(registry.errors.include?(:registration_number)).to eq true
      end
    end
    context 'length' do
      it 'falso quando é cadastrado um cpf com tamanho incorreto' do
        registry = FactoryBot.build(:blocked_registration_number, registration_number: '182939')

        registry.save

        expect(registry).not_to be_valid
        expect(registry.errors.include?(:registration_number)).to eq true
      end
    end
    context 'numericality' do
      it 'falso quando é cadastrado um cpf com caracteres não numéricos' do
        registry = FactoryBot.build(:blocked_registration_number, registration_number: 'ajskendome1')

        registry.save

        expect(registry).not_to be_valid
        expect(registry.errors.include?(:registration_number)).to eq true
      end
    end
  end
end
