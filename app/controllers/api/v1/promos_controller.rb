module Api
  module V1
    class PromosController < Api::V1::ApiController
      def index
        promos = Promo.all.select { |promo| promo.promo_products.present? }
        render status: :ok, json: json_format(promos)
      end

      private

      # rubocop:disable Metrics/MethodLength
      def json_format(promo)
        promo.map do |p|
          {
            id: p.id,
            name: p.name,
            starting_date: p.starting_date,
            ending_date: p.ending_date,
            usages_max: p.usages_max,
            discount_percentage: p.discount_percentage,
            discount_max: p.discount_max,
            voucher: p.voucher,
            insurance_company_id: p.insurance_company_id,
            products: p.promo_products.map(&:product_id)
          }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
