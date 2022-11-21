class Invoice < ApplicationRecord
  enum status: { pending: 0, paid: 1, failed: 2 }

  belongs_to :payment_method
  belongs_to :insurance_company

  validate :check_payment_method_options
  validates :transaction_registration_number, presence: true, on: :update, if: :paid?
  validates :reason_for_failure, presence: true, on: :update, if: :failed?

  before_validation :generate_token, on: :create

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end

  def check_payment_method_options
    return if insurance_company.payment_options.map(&:payment_method).include?(payment_method)

    errors.add(:payment_method, 'deve ter meio de pagamento escolhido por seguradora')
  end
end
