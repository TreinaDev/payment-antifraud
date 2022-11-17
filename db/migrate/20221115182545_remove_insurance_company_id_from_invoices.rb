class RemoveInsuranceCompanyIdFromInvoices < ActiveRecord::Migration[7.0]
  def change
    remove_column :invoices, :insurance_company_id, :integer
  end
end
