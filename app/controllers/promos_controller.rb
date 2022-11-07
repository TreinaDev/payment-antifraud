class PromosController < ApplicationController
  before_action :set_promo, only: %i[edit show]

  def index
    @promos = Promo.all
  end

  def show
    @promo = Promo.find(params[:id])
  end

  def new
    @promo = Promo.new
  end

  def edit; end

  def create
    @promo = Promo.new(promo_params)
    if @promo.save
      redirect_to promo_path(@promo.id), notice: I18n.t('controllers.promos.create.success')
    else
      flash.now[:notice] = I18n.t('controllers.promos.create.fail')
      render 'new'
    end
  end

  private

  def set_promo
    @promo = Promo.find(params[:id])
  end

  def promo_params
    params.require(:promo).permit(:name, :starting_date, :discount_max, :usages_max, :product_list, :ending_date,
                                  :discount_percentage)
  end
end
