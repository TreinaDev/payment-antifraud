class FraudReportsController < ApplicationController
  before_action :authenticate!

  def index
    if current_admin
      @fraud_reports = FraudReport.all.sort_by(&:status)
    else  
      @fraud_reports = current_user.insurance_company.fraud_reports.sort_by(&:status)
    end
  end

  def show 
    @fraud_report = FraudReport.find params[:id]
    if current_user
      unless @fraud_report.insurance_company_id == current_user.insurance_company_id
        redirect_to root_path, alert: t('no_access_granted')
      end
    end
  end
end
