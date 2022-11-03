class CreateFraudReports < ActiveRecord::Migration[7.0]
  def change
    create_table :fraud_reports do |t|
      t.string :registration_number
      t.string :description
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
