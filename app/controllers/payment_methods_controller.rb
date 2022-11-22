class PaymentMethodsController < ApplicationController
  before_action :require_admin
  include Pagination

  before_action :authenticate!
  before_action :set_payment_method, only: %i[show edit update]

  def index
    @pagination, @payment_methods = paginate(
      collection: PaymentMethod.all,
      params: page_params(10)
    )
  end

  def show; end

  def new
    @payment_method = PaymentMethod.new
    @payment_types = ['Pix', 'Boleto', 'Cartão de Crédito']
  end

  def edit
    @payment_method_status = PaymentMethod.statuses
    @payment_types = ['Pix', 'Boleto', 'Cartão de Crédito']
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      flash[:notice] = t(:payment_method_registered_success)
      redirect_to @payment_method
    else
      flash.now[:alert] = t(:not_possible_register_payment_method)
      @payment_types = ['Pix', 'Boleto', 'Cartão de Crédito']
      render 'new'
    end
  end

  def update
    if @payment_method.update(payment_method_params)
      flash[:notice] = t(:payment_method_updated_success)
      redirect_to @payment_method
    else
      flash.now[:alert] = t(:not_possible_update_payment_method)
      @payment_types = ['Pix', 'Boleto', 'Cartão de Crédito']
      render 'edit'
    end
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name, :tax_percentage, :tax_maximum, :payment_type, :status, :image)
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end
end
