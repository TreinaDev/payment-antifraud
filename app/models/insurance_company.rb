class InsuranceCompany < ApplicationRecord
  has_many :payment_options, class_name: 'CompanyPaymentOption', dependent: :destroy
  has_many :users, dependent: :destroy
end
