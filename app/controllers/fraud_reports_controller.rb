class FraudReportsController < ApplicationController
  include Pagination

  before_action :authenticate!, only: %i[index show]
  before_action :require_user, only: %i[new create]
  before_action :require_admin, only: %i[approves denies]
  before_action :fetch_fraud_report, only: %i[show approves denies]

  def index
    @pagination, @fraud_reports = paginate(
      collection: if current_admin
                    FraudReport.all
                  else
                    current_user.insurance_company.fraud_reports
                  end,
      params: page_params(10)
    )
  end

  def show
    return unless current_user && (@fraud_report.insurance_company_id != current_user.insurance_company_id)

    redirect_to root_path, alert: t('no_access_granted')
  end

  def new
    @fraud_report = FraudReport.new
  end

  def create
    @fraud_report = FraudReport.new new_fraud_report_params
    @fraud_report.insurance_company_id = current_user.insurance_company_id
    return redirect_to @fraud_report, notice: t('messages.fraud_success') if @fraud_report.save

    flash.now[:alert] = t('messages.fraud_fail')
    render 'new'
  end

  def approves
    @fraud_report.confirmed_fraud!
    BlockedRegistrationNumber.find_or_create_by!(registration_number: @fraud_report.registration_number)  

    flash.now[:notice] = t('messages.fraud_approved')
    render :show
  end

  def denies
    @fraud_report.denied!
    flash.now[:notice] = t('messages.fraud_denied')
    render :show
  end

  private

  def fetch_fraud_report
    @fraud_report = FraudReport.find params[:id]
  end

  def new_fraud_report_params
    params.require(:fraud_report).permit(
      :registration_number, :description, images: []
    )
  end
end
