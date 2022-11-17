class InsuranceCompany < ApplicationRecord
  has_many :payment_options, class_name: 'CompanyPaymentOption', dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :promos, dependent: :destroy
end
