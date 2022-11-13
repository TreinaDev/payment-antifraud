class CompanyPaymentOptionsController < ApplicationController
  before_action :require_user
  before_action :fetch_payment_methods, only: %i[new create]

  def index
    @payment_options = current_user.insurance_company.payment_options
  end

  def show
    @payment_option = CompanyPaymentOption.find params[:id]
  end

  def new
    @payment_option = CompanyPaymentOption.new
  end

  def create
    @payment_option = CompanyPaymentOption.new new_payment_option_params
    @payment_option.user = current_user
    @payment_option.insurance_company = current_user.insurance_company

    if @payment_option.save
      return redirect_to @payment_option, notice: t('messages.payment_option_created_with_success')
    end

    flash.now.alert = t('messages.not_created')
    render :new
  end

  private

  def fetch_payment_methods
    @payment_methods = PaymentMethod.all
  end

  def new_payment_option_params
    params.require(:company_payment_option).permit(
      :max_parcels, :single_parcel_discount, :payment_method_id
    )
  end
end
