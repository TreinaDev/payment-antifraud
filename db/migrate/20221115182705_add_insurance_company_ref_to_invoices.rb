class AddInsuranceCompanyRefToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :insurance_company, foreign_key: true
  end
end
