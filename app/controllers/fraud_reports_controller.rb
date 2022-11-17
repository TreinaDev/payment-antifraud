class FraudReportsController < ApplicationController
  before_action :require_admin

  def index
    @fraud_reports = FraudReport.all.sort_by(&:status)
  end
end
