require 'rails_helper'

describe ExternalInsuranceCompany do
  context '.new_with_json' do
    parsed_json_data = {
      id: 1,
      email_domain: 'paolaseguros.com.br',
      company_status: 0,
      company_token: 'ABC12345678BLA',
      token_status: 0
    }

    object = ExternalInsuranceCompany.new_with_json(parsed_json_data)

    expect(object.instance_of?(ExternalInsuranceCompany)).to be_truthy
    expect(object.id).to eq 1
    expect(object.email_domain).to eq 'paolaseguros.com.br'
    expect(object.company_status).to eq 0
    expect(object.company_token).to eq 'ABC12345678BLA'
    expect(object.token_status).to eq 0
  end
end
