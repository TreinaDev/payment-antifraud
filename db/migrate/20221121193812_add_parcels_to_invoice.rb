class AddParcelsToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :parcels, :integer
  end
end
