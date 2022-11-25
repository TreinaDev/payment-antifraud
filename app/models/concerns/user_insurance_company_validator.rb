class UserInsuranceCompanyValidator < ActiveModel::Validator
  def validate(record)
    return if record.insurance_company_id.presence

    company_data = consult_insurance_api_for_email_validation(record)
    company = InsuranceCompany.check_if_external_company_exists_locally(company_data)
    record.insurance_company_id = company.id
  end

  private

  def consult_insurance_api_for_email_validation(record)
    response = Faraday.get(
      "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/query",
      { id: record.email }
    )
    raise ActiveRecord::QueryCanceled if response.status == 500

    if response.status == 404
      record.errors.add(:email, 'deve pertencer a uma seguradora ativa.')
      raise ActiveRecord::Rollback
    end
    JSON.parse(response.body)
  end
end
