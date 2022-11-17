class FixIdentifyPackageId < ActiveRecord::Migration[7.0]
  def change
    rename_column :invoices, :identify_package_id, :package_id
  end
end
