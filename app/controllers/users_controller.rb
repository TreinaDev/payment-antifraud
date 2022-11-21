class UsersController < ApplicationController
  include Pagination

  before_action :require_admin

  def index
    @filter_options = { pending: 'Usuários pendentes', approved: 'Usuários aprovados', refused: 'Usuários reprovados' }
    @pagination, @users = paginate(
      collection: if params[:filter_option].present?
                    User.where(status: @filter_options.key(params[:filter_option]))
                  else
                    User.all
                  end,
      params: page_params(10)
    )
  end
end
