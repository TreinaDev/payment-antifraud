class AddInsuranceCompanyToFraudReports < ActiveRecord::Migration[7.0]
  def change
    add_reference :fraud_reports, :insurance_company, null: false, foreign_key: true
  end
end
