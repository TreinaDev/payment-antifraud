class InsuranceCompany < ApplicationRecord
  has_many :payment_options, class_name: 'CompanyPaymentOption', dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :promos, dependent: :destroy
  has_many :fraud_reports, dependent: :destroy

  def self.all_external
    companies_url = "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies"
    response = Faraday.get(companies_url)
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

    data = JSON.parse(response.body)
    data.map { |d| ExternalInsuranceCompany.parse_from(d) }
  end

  def self.active_external_company?(company)
    company.company_status.zero? && company.token_status.zero?
  end

  def self.check_if_user_email_match_any_external_company(user_email)
    companies = all_external
    companies.select do |company|
      return company if company.email_domain == user_email.split('@').last && active_external_company?(company)
    end
  end
end
