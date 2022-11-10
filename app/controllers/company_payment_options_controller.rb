class CompanyPaymentOptionsController < ApplicationController
  before_action :require_user 

  def index; end 
  
  def new 
    @payment_option = CompanyPaymentOption.new
    @payment_methods = PaymentMethod.active
  end

  def create 
    @payment_option = CompanyPaymentOption.new new_payment_option_params
    @payment_option.user = current_user 

    if @payment_option.save 
      return redirect_to company_payment_options_url, notice: 'Deu certo!'
    end
    render :new 
  end

  private 
   
    def new_payment_option_params 
      params.require(:company_payment_option).permit(
        :payment_method_id, :company_domain,
        :max_parcels, :single_parcel_discount
      )
    end
end