module Api
  module V1
    class InvoicesController < Api::V1::ApiController
      def show
        invoice = Invoice.find(params[:id])
        render status: :ok, json: invoice.as_json(except: %i[created_at updated_at])
      end

      def create
        invoice = parse_invoice(invoice_params)
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

      def parse_invoice(params)
        Invoice.new(
          total_price: params['final_price'],
          package_id: params['package_id'],
          registration_number: params['registration_number'],
          insurance_company_id: params['insurance_company_id'],
          order_id: params['order_id'],
          payment_method_id: params['payment_method_id'],
          voucher: params['voucher'],
          parcels: params['parcels']
        )
      end
    end
  end
end
