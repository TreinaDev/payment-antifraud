class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.integer :tax_percentage
      t.integer :tax_maximum
      t.string :payment_type
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
