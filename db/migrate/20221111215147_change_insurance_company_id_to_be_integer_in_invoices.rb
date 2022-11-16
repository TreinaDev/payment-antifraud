class ChangeInsuranceCompanyIdToBeIntegerInInvoices < ActiveRecord::Migration[7.0]
  def change
    change_column :invoices, :insurance_company_id, :integer
  end
end
