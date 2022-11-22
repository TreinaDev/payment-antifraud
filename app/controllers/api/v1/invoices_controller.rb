module Api
  module V1
    class InvoicesController < Api::V1::ApiController
      def index
        invoices = Invoice.all.order(order_id: :desc)
        render status: :ok, json: invoices.as_json
      end

      def show
        invoice = Invoice.find(params[:id])
        render status: :ok, json: invoice.as_json(except: %i[created_at updated_at])
      end

      def create
        invoice = Invoice.parse_from(invoice_params)
        if invoice.save
          render status: :created, json: { message: 'Sucesso.' }
        else
          render status: :precondition_failed, json: { errors: invoice.errors.full_messages }
        end
      end

      private

      def invoice_params
        params.require(:invoice).permit(:order_id, :insurance_company_id, :package_id, :registration_number,
                                        :payment_method_id, :parcels, :final_price, :voucher)
      end
    end
  end
end
