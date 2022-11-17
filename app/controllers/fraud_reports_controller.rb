class FraudReportsController < ApplicationController
  before_action :authenticate!

  def index
    if current_admin
      @fraud_reports = FraudReport.all.sort_by(&:status)
    else  
      @fraud_reports = current_user.insurance_company.fraud_reports.sort_by(&:status)
    end
  end
end
