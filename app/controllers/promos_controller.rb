class PromosController < ApplicationController
  before_action :require_user
  before_action :set_promo, only: %i[edit update show]

  def index
    @promos = Promo.where(insurance_company_id: current_user.insurance_company_id)
  end

  def show
    unless current_user.insurance_company_id == @promo.insurance_company_id
      return redirect_to root_path,
                         alert: t('no_access_granted')
    end

    registered_products = @promo.promo_products.map { |prod| prod&.product_id }
    @available_products = ProductsApi.products_array.map do |obj|
      obj unless registered_products.include?(obj[1])
    end.compact_blank
    @promo_product = PromoProduct.new
  end

  def new
    @promo = Promo.new
  end

  def edit; end

  def create
    @promo = Promo.new(promo_params)
    @promo.insurance_company_id = current_user.insurance_company_id
    if @promo.save
      redirect_to promo_path(@promo.id), notice: I18n.t('controllers.promos.create.success')
    else
      flash.now[:notice] = I18n.t('controllers.promos.create.fail')
      render 'new'
    end
  end

  def update
    if @promo.update(promo_params)
      redirect_to promo_path(@promo.id), notice: I18n.t('controllers.promos.update.success')
    else
      flash.now[:notice] = I18n.t('controllers.promos.update.fail')
      render 'edit'
    end
  end

  private

  def sanitize_discount_max
    params[:promo][:discount_max] = params[:promo][:discount_max].to_f * 100
  end

  def set_promo
    @promo = Promo.find(params[:id])
  end

  def promo_params
    sanitize_discount_max
    params.require(:promo).permit(:name, :starting_date, :discount_max, :usages_max, :ending_date,
                                  :discount_percentage)
  end
end
