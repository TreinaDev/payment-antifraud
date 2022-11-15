class InvoicesController < ApplicationController
  before_action :require_user
  def index
    @invoices = current_user.insurance_company.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
