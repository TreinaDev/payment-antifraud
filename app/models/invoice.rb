class Invoice < ApplicationRecord
  enum status: { pending: 0, payd: 1, failed: 2 }
  before_validation :generate_token, on: :create
  belongs_to :payment_method
  belongs_to :insurance_company
  # validate :check_payment_method_options

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end

  def check_payment_method_options
    unless insurance_company.payment_options.map(&:payment_method).include?(payment_method)
      errors.add(:payment_method, 'deve ter meio de pagamento escolhido por seguradora')
    end
  end
end
