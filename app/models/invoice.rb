class Invoice < ApplicationRecord
  enum status: { pending: 0, paid: 1, failed: 2 }
  before_validation :generate_token, on: :create
  belongs_to :payment_method
  belongs_to :insurance_company
  validate :presence_true_if_paid_or_failed, on: :update

  # validate :check_payment_method_options
  private

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end

  def check_payment_method_options
    return if insurance_company.payment_options.map(&:payment_method).include?(payment_method)

    errors.add(:payment_method, 'deve ter meio de pagamento escolhido por seguradora')
  end

  def presence_true_if_paid_or_failed
    if status == 'paid' && transaction_registration_number.blank?
      errors.add(:transaction_registration_number, I18n.t('errors.messages.blank'))
    end
    errors.add(:reason_for_failure, I18n.t('errors.messages.blank')) if status == 'failed' && reason_for_failure.blank?
  end
end
