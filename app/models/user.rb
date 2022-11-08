class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1, refused: 2 }
  has_one :user_approval, dependent: :destroy
  before_save :consult_insurance_company_api_for_email_validation
  validates :registration_number, presence: true
  validates :registration_number, length: { is:11 }

  private

  def consult_insurance_company_api_for_email_validation
    raise_company_error unless InsuranceCompany.user_email_match_any_company?(email)
  end

  def raise_company_error
    errors.add(:email, 'deve pertencer a uma seguradora ativa.')
  end
end
