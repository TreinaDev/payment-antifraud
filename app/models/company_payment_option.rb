class CompanyPaymentOption < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :insurance_company, dependent: :destroy
  belongs_to :payment_method, dependent: :destroy
end
