class AddVoucherToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :voucher, :string
  end
end
