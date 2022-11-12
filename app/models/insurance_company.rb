class InsuranceCompany < ApplicationRecord
  has_many :payment_options, class_name: 'CompanyPaymentOption'
  has_many :users
end
