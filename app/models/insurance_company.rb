class InsuranceCompany
  attr_accessor :id, :email_domain, :company_status, :company_token, :token_status

  def initialize(id:, email_domain:, company_status:, company_token:, token_status:)
    @id = id
    @email_domain = email_domain
    @company_status = company_status
    @company_token = company_token
    @token_status = token_status
  end

  def self.new_insurance_company(params)
    InsuranceCompany.new(
      id: params['id'],
      email_domain: params['email_domain'],
      company_status: params['company_status'],
      company_token: params['company_token'],
      token_status: params['token_status']
    )
  end

  def self.find(id)
    response = Faraday.get("https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies#{id}")
    raise ActiveRecord::RecordNotFound if response.status == 404 
    raise ActiveRecord::QueryCanceled if response.status == 500
    new_insurance_company(JSON.parse(response.body))
  end

  def self.all
    response = Faraday.get('https://636c2fafad62451f9fc53b2e.mockapi.io/api/v1/insurance_companies')
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

    data = JSON.parse(response.body)
    data.map { |d| new_insurance_company(d) }
  end

  def self.active_company?(company)
    company.company_status.zero? && company.token_status.zero?
  end

  def self.user_email_match_any_company?(user_email)
    companies = all
    companies.each do |company|
      return true if company.email_domain == user_email.split('@').last && active_company?(company)
    end
    false
  end
end
