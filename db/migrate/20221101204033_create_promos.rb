class CreatePromos < ActiveRecord::Migration[7.0]
  def change
    create_table :promos do |t|
      t.date :starting_date
      t.date :ending_date
      t.string :name
      t.integer :discount_percentage
      t.integer :discount_max
      t.string :product_list
      t.integer :usages_max
      t.string :voucher

      t.timestamps
    end
  end
end
