class RemoveProductCategoryColumnFromPromoProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :promo_products, :product_category
  end
end
