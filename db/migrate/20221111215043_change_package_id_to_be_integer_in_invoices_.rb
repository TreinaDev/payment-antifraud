class ChangePackageIdToBeIntegerInInvoices < ActiveRecord::Migration[7.0]
  def change
    change_column :invoices, :package_id, :integer
  end
end
