class CreateCompanyPaymentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :company_payment_options do |t|
      t.references :user, null: false, foreign_key: true
      t.references :insurance_company, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.integer :max_parcels
      t.integer :single_parcel_discount

      t.timestamps
    end
  end
end
