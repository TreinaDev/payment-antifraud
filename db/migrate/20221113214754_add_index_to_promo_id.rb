class AddIndexToPromoId < ActiveRecord::Migration[7.0]
  def change
    add_index :promo_products, [:promo_id, :product_id], unique:true
  end
end
