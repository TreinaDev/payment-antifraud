class PromoProductsController < ApplicationController
  before_action :set_promo_product, only: %i[ show edit update destroy ]

  def create

    @promo = Promo.find(params[:promo_id])
    @promo_product = PromoProduct.new(promo_product_params)
    @promo_product.promo = @promo
    
      if @promo_product.save
        redirect_to @promo, alert: 'Produto adicionado com sucesso.'
      else

    end
  end

  def destroy
    @promo_product.destroy
  end

  private 
    def set_promo_product
      @promo_product = PromoProduct.find(params[:id])
    end

    def promo_product_params
      params.require(:promo_product).permit(:product_id, :promo_id)
    end
end
