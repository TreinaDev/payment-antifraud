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

  def self.check_if_external_company_exists_locally(company_data)
    local_company = InsuranceCompany.find_by external_insurance_company: company_data[:id]
    if local_company.nil?
    local_company = InsuranceCompany.create!(external_insurance_company: company_data[:id])
    end
    local_company    
  end
end
