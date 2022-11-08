require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'CPF' do
      it 'Falso se o usuário estiver sem CPF' do
        user = FactoryBot.build(:user, registration_number: nil)

        expect(user).not_to be_valid
      end

      it 'Falso se o usuário cadastrar um CPF com menos de 11 caracteres' do
        user = FactoryBot.build(:user, registration_number: '293')

        expect(user).not_to be_valid
      end

      it 'Falso se o usuário cadastrar um CPF com mais de 11 caracteres' do
        user = FactoryBot.build(:user, registration_number: '2930493012038210321890390')

        expect(user).not_to be_valid
      end
    end
  end
end
