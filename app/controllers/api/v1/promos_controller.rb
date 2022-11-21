module Api
  module V1
    class PromosController < Api::V1::ApiController
      def show
        promo = Promo.find_by(voucher: params[:voucher])
        raise ActiveRecord::RecordNotFound if promo.blank?

        render status: :ok, json: promo_json(promo)
      end

      private

      def product_not_in_promo?(promo)
        promo.promo_products.map(&:product_id).none? params[:product_id].to_i
      end

      def promo_json(promo)
        if Time.zone.today > promo.ending_date
          { status: 'Cupom expirado.' }
        elsif Time.zone.today < promo.starting_date || product_not_in_promo?(promo)
          { status: 'Cupom inválido.' }
        else
          { status: 'Cupom válido.', discount: promo.promo_discount(params[:price].to_i) }
        end
      end
    end
  end
end
