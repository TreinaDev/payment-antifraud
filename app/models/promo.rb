class Promo < ApplicationRecord
  validates :name, :starting_date, :discount_max, :usages_max, :product_list, :ending_date, :discount_percentage,
            presence: true
  before_validation :generate_voucher, on: :create

  private

  def generate_voucher
    self.voucher = SecureRandom.alphanumeric(8).upcase
  end
end
