class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update]
  before_action :invoice_params, only: %i[update]
  before_action :require_user
  def index
    @invoices = current_user.insurance_company.invoices
  end

  def show; end

  def edit
    @invoice.status = params[:status]
  end

  def update
    if @invoice.update(invoice_params) && patch_external_invoice_status
      flash[:notice] = t('messages.charge_updated_successfully')
      redirect_to @invoice
    else
      flash.now[:alert] = t('messages.charge_not_updated')
      render 'edit'
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:status, :token, :package_id, :registration_number,
                                    :insurance_company_id, :order_id, :payment_method_id, :voucher,
                                    :transaction_registration_number, :reason_for_failure)
  end

  def patch_external_invoice_status
    invoice_url = "#{Rails.configuration.external_apis['comparator_api_invoices_endpoint']}#{@invoice.order_id}"
    params = { status: @invoice.status, token: @invoice.status }
    response = Faraday.patch(invoice_url, params)
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

    response
  end
end
