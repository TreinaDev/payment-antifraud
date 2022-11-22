module Api
  module V1
    class BlockedRegistrationNumbersController < Api::V1::ApiController
      def show
        registration_number = BlockedRegistrationNumber.find_by(registration_number: params[:id])
        render status: :ok, json: { blocked: registration_number.present? }
      end
    end
  end
end
