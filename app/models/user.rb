class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1, refused: 2 }
  has_one :user_review, dependent: :destroy
  belongs_to :insurance_company, dependent: :destroy, optional: true
  validates_with UserInsuranceCompanyValidator
  validates :registration_number, presence: true
  validates :registration_number, length: { is: 11 }

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end
end
