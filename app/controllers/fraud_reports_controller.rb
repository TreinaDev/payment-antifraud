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

  def new 
    @fraud_report = FraudReport.new
  end

  def create
    @fraud_report = FraudReport.new new_fraud_report_params
    if @fraud_report.save
      return redirect_to fraud_reports_path, notice: t('messages.fraud_success')
    end
    flash.now[:alert] = t('messages.fraud_fail')      
    render 'new'
  end

  private

  def new_fraud_report_params 
    params.require(:fraud_report).permit(:registration_number,
                                         :description, images: [])
  end
end
