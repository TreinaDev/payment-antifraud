module Api
  module V1
    class FraudReportsController < Api::V1::ApiController
      def show
        fraud_report = FraudReport.find_by(registration_number: params[:id])
        render status: :ok, json: fraud_report_json_format(fraud_report)
      end

      private

      def fraud_report_json_format(fraud_report)
        if fraud_report&.confirmed_fraud?
          { blocked: true }
        else
          { blocked: false }
        end
      end
    end
  end
end
