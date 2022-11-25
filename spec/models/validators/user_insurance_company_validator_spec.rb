require 'rails_helper'

describe UserInsuranceCompanyValidator do
  describe '.validate' do
    context 'Consulta se o e-mail do usuário bate com alguma seguradora da app de seguradoras' do
      it 'e valida com sucesso' do
        company = ExternalInsuranceCompany.new(
          id: 1,
          email_domain: 'paolaseguros.com.br',
          company_status: 0,
          company_token: 'TOKENEXPIRADODESDE1999',
          token_status: 0
        )
        fake_response = double('Faraday::Response', status: 200, body: company.to_json)
        new_user = FactoryBot.build(:user, email: 'paola@paolaseguros.com.br')
        allow(Faraday)
          .to receive(:get)
          .with(
            "#{Rails.configuration.external_apis['insurance_api']}/companies/validate_email",
            { email: new_user.email }
          )
          .and_return(fake_response)

        expect(new_user.save).to be_truthy
      end

      it 'e não há seguradoras com o e-mai que o usuário inseriu' do
        fake_response = double('Faraday::Response', status: 200, body: [])
        new_user = FactoryBot.build(:user, email: 'paola@emailquenaoexiste.br')
        allow(Faraday)
          .to receive(:get)
          .with(
            "#{Rails.configuration.external_apis['insurance_api']}/companies/validate_email",
            { email: new_user.email }
          )
          .and_return(fake_response)

        expect(new_user.save).to be_falsy
        expect(new_user.errors.include?(:email)).to be_truthy
        expect(new_user.errors.first.full_message).to eq 'E-mail deve pertencer a uma seguradora ativa.'
      end
    end
  end
end
