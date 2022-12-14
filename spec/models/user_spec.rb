require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'CPF' do
      it 'Falso se o usuário estiver sem CPF' do
        company = create(:insurance_company)
        user = build(:user, registration_number: nil, insurance_company_id: company.id)

        expect(user).not_to be_valid
        expect(user.errors.include?(:registration_number)).to be_truthy
      end

      it 'Falso se o usuário cadastrar um CPF com menos de 11 caracteres' do
        company = create(:insurance_company)
        user = build(:user, registration_number: '293', insurance_company_id: company.id)

        expect(user).not_to be_valid
        expect(user.errors.include?(:registration_number)).to be_truthy
      end

      it 'Falso se o usuário cadastrar um CPF com mais de 11 caracteres' do
        company = create(:insurance_company)
        user = build(
          :user,
          registration_number: '2930493012038210321890390',
          insurance_company_id: company.id
        )

        expect(user).not_to be_valid
        expect(user.errors.include?(:registration_number)).to be_truthy
      end
    end
  end
end
