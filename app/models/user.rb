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
    raise_company_error unless InsuranceCompany.user_email_match_any_company?(email)
  end

  def raise_company_error
    errors.add(:email, 'deve pertencer a uma seguradora ativa.')
    raise ActiveRecord::Rollback
  end

  def domain
    email.split('@').last
  end
end
