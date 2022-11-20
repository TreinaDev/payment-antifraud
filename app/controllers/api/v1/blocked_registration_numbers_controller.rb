module Api
  module V1
    class BlockedRegistrationNumbersController < Api::V1::ApiController
      def show
        registration_number = BlockedRegistrationNumber.find_by(registration_number: params[:id])
        render status: :ok, json: registration_number_check_json_format(registration_number)
      end

      private

      def registration_number_check_json_format(registration_number)
        if registration_number.present?
          { blocked: true }
        else
          { blocked: false }
        end
      end
    end
  end
end
