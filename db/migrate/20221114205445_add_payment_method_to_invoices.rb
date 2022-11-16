class AddPaymentMethodToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :payment_method, foreign_key: true
  end
end
