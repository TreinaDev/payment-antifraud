class RemoveProductListColumnFromPromo < ActiveRecord::Migration[7.0]
  def change
    remove_column :promos, :product_list
  end
end
