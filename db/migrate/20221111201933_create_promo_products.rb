class CreatePromoProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :promo_products do |t|
      t.string :product_model
      t.integer :product_id
      t.references :promo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
