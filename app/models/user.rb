class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1, refused: 2 }
  has_one :user_review, dependent: :destroy
  belongs_to :insurance_company, dependent: :destroy
  before_validation :consult_insurance_company_api_for_email_validation, on: :create
  validates :registration_number, presence: true
  validates :registration_number, length: { is: 11 }

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  private

  def consult_insurance_company_api_for_email_validation
    search_result = InsuranceCompany.check_if_user_email_match_any_external_company(email)
    raise_company_error if search_result == []
    check_if_company_already_exists_locally(search_result)
  end

  def check_if_company_already_exists_locally(company)
    match = InsuranceCompany.find_by external_insurance_company: company.id
    if match.nil?
      new_company = InsuranceCompany.create!(external_insurance_company: company.id)
      self.insurance_company_id = new_company.id
    else
      self.insurance_company_id = match.id
    end
  end

  def raise_company_error
    errors.add(:email, 'deve pertencer a uma seguradora ativa.')
    raise ActiveRecord::Rollback
  end
end
