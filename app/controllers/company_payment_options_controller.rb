class CompanyPaymentOptionsController < ApplicationController
  before_action :require_user

  def index
    @payment_options = current_user.insurance_company.payment_options
  end

  def show
    @payment_option = CompanyPaymentOption.find params[:id]
  end
end
