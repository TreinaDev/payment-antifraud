class Promo < ApplicationRecord
  validates :name, :starting_date, :discount_max, :usages_max, :product_list, :ending_date, :discount_percentage,
            presence: true
  validate :ending_date_greater_than_starting_date
  before_validation :generate_voucher, on: :create

  private

  def ending_date_greater_than_starting_date
    if self.starting_date > self.ending_date
      errors.add(:ending_date, I18n.t('activerecord.errors.models.promo.attributes.ending_date.date_error'))
    end
  end

  def generate_voucher
    self.voucher = SecureRandom.alphanumeric(8).upcase
  end
end
