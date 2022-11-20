class UsersController < ApplicationController
  include Pagination

  before_action :require_admin

  def index
    @pagination, @users = paginate(
      collection: User.all,
      params: page_params(10)
    )
  end
end
