class CompanyPaymentOptionsController < ApplicationController
  def index
    @payment_options = current_user.insurance_company.payment_options
  end
end