require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'CPF' do
      it 'Falso se o usuário estiver sem CPF' do
        user = FactoryBot.build(:user, registration_number: nil)

        expect(user).not_to be_valid
        expect(user.errors.include?(:registration_number)).to be_truthy
      end

      it 'Falso se o usuário cadastrar um CPF com menos de 11 caracteres' do
        user = FactoryBot.build(:user, registration_number: '293')

        expect(user).not_to be_valid
        expect(user.errors.include?(:registration_number)).to be_truthy
      end

      it 'Falso se o usuário cadastrar um CPF com mais de 11 caracteres' do
        user = FactoryBot.build(:user, registration_number: '2930493012038210321890390')

        expect(user).not_to be_valid
        expect(user.errors.include?(:registration_number)).to be_truthy
      end
    end
  end

  describe '#check_if_company_already_exists_locally' do
    it 'verifica se a seguradora já possui registro na aplicação, e adiciona id da seguradora ao usuário' do
      company = InsuranceApi.new(
        id: 1,
        email_domain: 'petra@paolaseguros.com.br',
        company_status: 0,
        company_token: 'TOKENEXPIRADODESDE1999',
        token_status: 0
      )
      allow(InsuranceApi).to receive(:check_if_user_email_match_any_company).and_return(company)
      FactoryBot.create(:insurance_company, external_insurance_company: company.id)
      user = User.create(email: 'petra@paolaseguros.com.br',
                         password: 'password',
                         name: 'Petra',
                         registration_number: '39401929301',
                         status: :pending,
                         )

      expect(user.insurance_company_id).to eq company.id
      expect(InsuranceCompany.count).to eq 1
    end

    it 'seguradora não possuia resgistro na aplicação, salva a seguradora e adiciona o id da seguradora ao usuário' do
      company = InsuranceApi.new(
        id: 1,
        email_domain: 'petra@paolaseguros.com.br',
        company_status: 0,
        company_token: 'TOKENEXPIRADODESDE1999',
        token_status: 0
      )
      allow(InsuranceApi).to receive(:check_if_user_email_match_any_company).and_return(company)
      user = User.create(email: 'petra@paolaseguros.com.br',
                         password: 'password',
                         name: 'Petra',
                         registration_number: '39401929301',
                         status: :pending)

      expect(user.insurance_company_id).to eq company.id
      expect(InsuranceCompany.count).to eq 1
      expect(InsuranceCompany.first.external_insurance_company).to eq company.id
    end
  end
end
