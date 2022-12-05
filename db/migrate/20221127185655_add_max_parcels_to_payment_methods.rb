class AddMaxParcelsToPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    add_column :payment_methods, :max_parcels, :integer
  end
end
