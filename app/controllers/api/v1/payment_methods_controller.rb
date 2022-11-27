module Api
  module V1
    class PaymentMethodsController < Api::V1::ApiController
      def show
        @payment_method = PaymentMethod.find(params[:id])
        render status: :ok, json: payment_method_json_with_image_url
      end

      private

      def payment_method_json_with_image_url
        {
          name: @payment_method.name,
          payment_type: @payment_method.payment_type,
          image_url: url_for(@payment_method.image),
          tax_percentage: @payment_method.tax_percentage,
          tax_maximum: @payment_method.tax_maximum,
          max_parcels: @payment_method.max_parcels
        }.as_json
      end
    end
  end
end
