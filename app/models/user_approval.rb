class UserApproval < ApplicationRecord
  belongs_to :user
  before_validation :validates_refusal_when_registration_is_approved_or_denied

  private

  def validates_refusal_when_registration_is_approved_or_denied
    if status && refusal.present?
      errors.add(:refusal, 'não pode ser preenchido para aprovar o cadastro.')
    elsif !status && refusal.blank?
      errors.add(:refusal, 'deve ser preenchido para recusar o cadastro.')
    end
  end
end
