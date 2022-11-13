class PromoProduct < ApplicationRecord
  belongs_to :promo
  validates :product_id, presence: true, uniqueness: { scope: :promo_id }
end
