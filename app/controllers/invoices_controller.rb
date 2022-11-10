class InvoicesController < ApplicationController
  before_action :require_user
  def index
    @invoices = Invoice.all
  end
end
