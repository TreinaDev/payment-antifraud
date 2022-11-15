class Api::V1::PromosController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_404

  def show
    promo = Promo.find(params[:id])
    render status: 200, json: promo
  end

  def index
    promos = Promo.all
    render status: 200, json: promos
  end

  private

  def return_500
    render status: 500, json: {}
  end

  def return_404
    render status: 404, json: {}
  end
end