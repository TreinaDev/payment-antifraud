module Api
  module V1
    class PromosController < Api::V1::ApiController
      def show
        promo = Promo.find_by(voucher: params[:id].split('-')[1])
        raise ActiveRecord::RecordNotFound if promo.blank?

        render status: :ok, json: promo_json(promo)
      end

      private

      def product_not_in_promo?(promo)
        promo.promo_products.map(&:product_id).none? params[:id].split('-')[0].to_i
      end

      # rubocop:disable Metrics/MethodLength
      def promo_json(promo)
        if Time.zone.today > promo.ending_date
          {
            status: 'Cupom expirado.'
          }
        elsif Time.zone.today < promo.starting_date || product_not_in_promo?(promo)
          {
            status: 'Cupom inválido.'
          }
        else
          {
            status: 'Cupom válido.'
          }
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
