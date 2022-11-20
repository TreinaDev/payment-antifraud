class InvoicesController < ApplicationController
  include Pagination

  before_action :require_user
  def index
    @pagination, @invoices = paginate(
      collection: current_user.insurance_company.invoices,
      params: page_params(10)
    )
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
