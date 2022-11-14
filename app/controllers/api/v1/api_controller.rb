module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      private

      def return404
        render status: :not_found, body: {}
      end

      def return500
        render status: :internal_server_error, body: {}
      end
    end
  end
end
