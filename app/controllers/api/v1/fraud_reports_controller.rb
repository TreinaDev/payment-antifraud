module Api
  module V1
    class FraudReportsController < Api::V1::ApiController
      def show
        fraud_report = FraudReport.find_by(registration_number: params[:id])
        return render status: :ok, json: fraud_report_json_format(fraud_report) if fraud_report.present?

        raise ActiveRecord::RecordNotFound
      end

      private

      def fraud_report_json_format(report)
        if FraudReport.confirmed_fraud.include? report
          { blocked: true }
        else
          { blocked: false }
        end
      end
    end
  end
end
