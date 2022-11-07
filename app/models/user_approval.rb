class UserApproval < ApplicationRecord
  belongs_to :user

  before_validation :ensure_refusal_when_registration_is_refused

  private

  def ensure_refusal_when_registration_is_refused
    return unless (!status && refusal.nil?) || (!status && refusal.empty?)
    
    errors.add(:refusal, 'deve ser preenchido para recusar o cadastro.')
  end
end
