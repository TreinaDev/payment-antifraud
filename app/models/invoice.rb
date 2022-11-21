class Invoice < ApplicationRecord
  enum status: { pending: 0, paid: 1, failed: 2 }

  belongs_to :payment_method
  belongs_to :insurance_company

  validate :check_payment_method_options
  validates :transaction_registration_number, presence: true, on: :update, if: :paid?
  validates :reason_for_failure, presence: true, on: :update, if: :failed?

  before_validation :generate_token, on: :create

  def self.parse_from(json)
    Invoice.new(
      total_price: json['final_price'],
      package_id: json['package_id'],
      registration_number: json['registration_number'],
      insurance_company_id: json['insurance_company_id'],
      order_id: json['order_id'],
      payment_method_id: json['payment_method_id'],
      voucher: json['voucher'],
      parcels: json['parcels']
    )
  end

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end

  def check_payment_method_options
    return if insurance_company.payment_options.map(&:payment_method).include?(payment_method)

    errors.add(:payment_method, 'deve ter meio de pagamento escolhido por seguradora')
  end
end
