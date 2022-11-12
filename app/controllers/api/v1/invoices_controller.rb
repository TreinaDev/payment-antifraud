class Api::V1::InvoicesController < Api::V1::ApiController
  def index
    invoices = Invoice.all.order(order_id: :desc)
    render status: :ok, json: invoices.as_json
  end

  def show
    invoice = Invoice.find(params[:id])
    render status: :ok, json: invoice.as_json(except: %i[created_at updated_at])
  end

  def create
    invoice = Invoice.new(invoice_params)
    if invoice.save
      render status: :created, json: invoice.as_json
    else
      render status: :precondition_failed, json: { errors: invoice.errors.full_messages }
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:order_id, :insurance_company_id, :package_id, :registration_number)
  end

end