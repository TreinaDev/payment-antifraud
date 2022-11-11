class AddOrderIdToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :order_id, :integer
  end
end
