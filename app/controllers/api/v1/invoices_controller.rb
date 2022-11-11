class Api::V1::InvoicesController < Api::V1::ApiController
  def show
    invoice = Invoice.find(params[:id])
    render status: 200, json: invoice.as_json(except: [:created_at, :updated_at])
  end

  def index
    invoices = Invoice.all.order(:name)
    render json: invoices.as_json, status: 200
  end

  def create
    invoice = Invoice.new(invoice_params)
    if invoice.save
      render status: 201, json: invoice.as_json
    else
      render status: 412, json: { errors: invoice.errors.full_messages }
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:order_id, :insurance_company_id, :package_id, :registration_number)
  end

end