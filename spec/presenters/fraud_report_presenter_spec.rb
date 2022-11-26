require 'rails_helper'

describe FraudReportPresenter do
  context '#formatted_registration_number' do
    it 'formata o número de 11 dígitos conforme o padrão do CPF brasileiro' do
      company = create(:insurance_company)
      fraud_report = build(
        :fraud_report,
        insurance_company: company,
        registration_number: '12345678911'
      )

      result = fraud_report.decorate.formatted_registration_number

      expect(result).to eq '123.456.789-11'
    end
  end
end
