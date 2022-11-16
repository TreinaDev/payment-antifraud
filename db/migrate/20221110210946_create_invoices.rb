class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :token
      t.string :insurance_company_id
      t.string :identify_package_id
      t.string :registration_number
      t.string :status, default: 0, null: false

      t.timestamps
    end
  end
end
