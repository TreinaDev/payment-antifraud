class PromoProductsController < ApplicationController
  before_action :set_promo_product, only: %i[destroy]
  before_action :set_promo, only: %i[create destroy]

  def create
    @promo_product = PromoProduct.new(promo_product_params)
    @promo_product.promo = @promo

    redirect_to @promo, notice: t('promo_product_create') if @promo_product.save
  end

  def destroy
    redirect_to @promo, notice: t('promo_product_destroy') if @promo_product.destroy
  end

  private

  def set_promo_product
    @promo_product = PromoProduct.find(params[:id])
  end

  def set_promo
    @promo = Promo.find(params[:promo_id])
  end

  def promo_product_params
    params.require(:promo_product).permit(:product_id, :promo_id)
  end
end
