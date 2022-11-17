class ExternalInsuranceCompany
  attr_accessor :id, :email_domain, :company_status, :company_token, :token_status

  def initialize(id:, email_domain:, company_status:, company_token:, token_status:)
    @id = id
    @email_domain = email_domain
    @company_status = company_status
    @company_token = company_token
    @token_status = token_status
  end

  def self.new_with_json(json)
    ExternalInsuranceCompany.new(
      id: json['id'],
      email_domain: json['email_domain'],
      company_status: json['company_status'],
      company_token: json['company_token'],
      token_status: json['token_status']
    )
  end
end
