class InvoicesController < ApplicationController
  before_action :require_user
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
