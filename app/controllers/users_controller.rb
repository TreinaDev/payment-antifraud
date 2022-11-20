class UsersController < ApplicationController
  before_action :require_admin

  def index
    @filter_options = { pending: 'Usuários pendentes', approved: 'Usuários aprovados', refused: 'Usuários reprovados' }
    @users = if params[:filter_option].present?
               User.where(status: @filter_options.key(params[:filter_option]))
             else
               User.all.sort_by(&:status)
             end
  end
end
