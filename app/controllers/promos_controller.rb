class PromosController < ApplicationController
  def index
    @promos = Promo.all
  end

  def show
    @promo = Promo.find(params[:id])
  end

  def new
    @promo = Promo.new
  end

  def create
    @promo = Promo.new(promo_params)
    if @promo.save
      redirect_to promo_path(@promo.id), notice: 'Promoção cadastrada com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível cadastrar a promoção'
      render 'new'
    end
  end

  private

  def promo_params
    params.require(:promo).permit(:name, :starting_date, :discount_max, :usages_max, :product_list, :ending_date,
                                  :discount_percentage)
  end
end
