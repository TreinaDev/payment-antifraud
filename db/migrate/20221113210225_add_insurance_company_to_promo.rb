class AddInsuranceCompanyToPromo < ActiveRecord::Migration[7.0]
  def change
    add_reference :promos, :insurance_company, foreign_key: true
  end
end
