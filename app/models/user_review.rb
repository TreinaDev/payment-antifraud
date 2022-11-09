class UserReview < ApplicationRecord
  belongs_to :user
  before_validation :validates_refusal_when_registration_is_approved_or_refused
  enum status: { approved: 0, refused: 1 }

  private

  def validates_refusal_when_registration_is_approved_or_refused
    if approved? && refusal.present?
      errors.add(:refusal, 'não pode ser preenchido para aprovar o cadastro.')
    elsif refused? && refusal.blank?
      errors.add(:refusal, 'deve ser preenchido para recusar o cadastro.')
    end
  end
end
