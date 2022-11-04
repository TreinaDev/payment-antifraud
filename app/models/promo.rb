class Promo < ApplicationRecord
  validates :name, :starting_date, :discount_max, :usages_max, :product_list, :ending_date, :discount_percentage,
            presence: true
end
