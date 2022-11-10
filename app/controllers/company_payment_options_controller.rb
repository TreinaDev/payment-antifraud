class CompanyPaymentOptionsController < ApplicationController
  def index; end 

  def new 
    @payment_option = CompanyPaymentOption.new
    @payment_methods = PaymentMethod.active
  end

end