class AddColumnsToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :transaction_registration_number, :string
    add_column :invoices, :reason_for_failure, :string
  end
end
