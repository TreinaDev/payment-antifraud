class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: [:show]

  def show; end

  def new
    @payment_method = PaymentMethod.new
    @payment_types = ['Pix', 'Boleto', 'Cartão de Crédito']
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      redirect_to @payment_method, notice: 'Meio de Pagamento registrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível registrar o meio de pagamento.'
      @payment_types = ['Pix', 'Boleto', 'Cartão de Crédito']
      render 'new'
    end
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name, :tax_percentage, :tax_maximum, :payment_type)
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end
end
