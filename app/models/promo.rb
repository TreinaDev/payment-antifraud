class Promo < ApplicationRecord
  validates :name, :starting_date, :discount_max, :usages_max, :ending_date, :discount_percentage,
            presence: true
  validates :usages_max, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :discount_percentage, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :ending_date_greater_than_starting_date
  before_validation :generate_voucher, on: :create
  has_many :promo_products, dependent: :destroy
  belongs_to :insurance_company, dependent: :destroy

  def currency
    discount_max.nil? ? 0 : discount_max / 100
  end

  def same_company(user)
    user.insurance_company_id == insurance_company_id
  end

  def promo_discount(payment_value)
    return discount_max if (discount_percentage * payment_value) / 100 >= discount_max

    (discount_percentage * payment_value) / 100
  end

  def self.voucher_count(voucher)
    Invoice.where(voucher:).where.not(status: :refused).count
  end

  private

  def ending_date_greater_than_starting_date
    return unless starting_date && ending_date && starting_date > ending_date

    errors.add(:ending_date, I18n.t('activerecord.errors.models.promo.attributes.ending_date.date_error'))
  end

  def generate_voucher
    self.voucher = SecureRandom.alphanumeric(8).upcase
  end
end
