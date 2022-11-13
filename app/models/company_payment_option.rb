class CompanyPaymentOption < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :insurance_company, dependent: :destroy
  belongs_to :payment_method, dependent: :destroy

  before_save :check_if_payment_type_can_be_parceled
  validates :max_parcels, :single_parcel_discount, presence: true
  validates :max_parcels, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  private

  def check_if_payment_type_can_be_parceled
    raise_payment_type_error if max_parcels > 1 && (payment_method.payment_type != 'Cartão de Crédito')
  end

  def raise_payment_type_error
    errors.add(:payment_method, 'não pode ser parcelado')
    raise ActiveRecord::Rollback
  end
end
