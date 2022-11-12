class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1, refused: 2 }
  has_one :user_review, dependent: :destroy
  before_create :consult_insurance_company_api_for_email_validation
  validates :registration_number, presence: true
  validates :registration_number, length: { is: 11 }

  private

  def consult_insurance_company_api_for_email_validation
    search_result = InsuranceApi.check_if_user_email_match_any_company(email)
    raise_company_error if search_result == []
    check_if_company_already_exists_locally(search_result)
  end

  def check_if_company_already_exists_locally(company)
    found = InsuranceCompany.find_by external_insurance_company: company.id
    if found.nil?
      new_company = InsuranceCompany.create!(external_insurance_company: company.id)
      self.insurance_company_id = new_company.id
    else
      self.insurance_company_id = found.id
    end
  end

  def raise_company_error
    errors.add(:email, 'deve pertencer a uma seguradora ativa.')
    raise ActiveRecord::Rollback
  end
end
