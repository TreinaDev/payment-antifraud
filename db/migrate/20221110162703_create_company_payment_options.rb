class CreateCompanyPaymentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :company_payment_options do |t|
      t.references :user, null: false, foreign_key: true
      t.string :company_domain
      t.references :payment_method, null: false, foreign_key: true
      t.integer :max_parcels
      t.integer :single_parcel_discount, default: 0

      t.timestamps
    end
  end
end
