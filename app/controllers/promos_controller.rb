class PromosController < ApplicationController
  def index
    @promos = Promo.all
  end

  def new
    @promo = Promo.new
  end

  
end