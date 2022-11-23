class InvoicesController < ApplicationController
  include Pagination

  before_action :set_invoice, only: %i[show edit update]
  before_action :require_user

  def index
    @pagination, @invoices = paginate(
      collection: current_user.insurance_company.invoices,
      params: page_params(10)
    )
  end

  def show 
    @insurance_company_id = @invoice.get_insurance_company_id
    @package_id = @invoice.get_package_id
  end

  def edit
    @invoice.status = params[:status]
  end

  def update
    @invoice.attributes = invoice_params
    if @invoice.valid? && post_external_invoice_sucess?
      @invoice.update(invoice_params)
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
                                    :insurance_company_id, :order_id, :payment_method_id,
                                    :voucher, :parcels, :total_price,
                                    :transaction_registration_number, :reason_for_failure)
  end

  def post_external_invoice_sucess?
    response = post_external_invoice
    return false if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

    response
  end

  def post_external_invoice
    invoice_approved_url = "#{Rails.configuration.external_apis['comparator_api']}/orders/
    #{@invoice.order_id}/payment_approved"
    invoice_refused_url = "#{Rails.configuration.external_apis['comparator_api']}/orders/
    #{@invoice.order_id}/payment_refused"
    params = { message: 'Success.' }
    if @invoice.approved?
      Faraday.post(invoice_approved_url, params)
    elsif @invoice.refused?
      Faraday.post(invoice_refused_url, params)
    end
  end
end
