module Api
  module V1
    class PromosController < Api::V1::ApiController
      def show
        promo = Promo.find_by(voucher: params[:id])
        return render status: :ok, json: promo_json_format(promo) if promo.present?

        raise ActiveRecord::RecordNotFound
      end

      private

      # rubocop:disable Metrics/MethodLength
      def promo_json_format(promo)
        {
          id: promo.id,
          voucher: promo.voucher,
          name: promo.name,
          starting_date: promo.starting_date,
          ending_date: promo.ending_date,
          usages_max: promo.usages_max,
          discount_percentage: promo.discount_percentage,
          discount_max: promo.discount_max,
          insurance_company_id: promo.insurance_company_id,
          products: promo.promo_products.map(&:product_id)
        }

        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
