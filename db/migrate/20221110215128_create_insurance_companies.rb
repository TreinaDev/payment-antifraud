class CreateInsuranceCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :insurance_companies do |t|
      t.integer :external_insurance_company

      t.timestamps
    end
  end
end
