module Api
  module V1
    class PromosController < Api::V1::ApiController
      def index
        promos = Promo.all
        render status: :ok, json: promos
      end

      def show
        promo = Promo.find(params[:id])
        render status: :ok, json: promo
      end
    end
  end
end
