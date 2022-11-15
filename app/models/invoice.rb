class Invoice < ApplicationRecord
  enum status: { pending: 0, payd: 1, failed: 2 }
  before_validation :generate_token, on: :create
  belongs_to :payment_method
  belongs_to :insurance_company

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end
end
