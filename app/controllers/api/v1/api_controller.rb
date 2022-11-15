module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return_internal_server_error
      rescue_from ActiveRecord::RecordNotFound, with: :return_not_found

      private

      def return_internal_server_error
        render status: :internal_server_error, json: {}
      end

      def return_not_found
        render status: :not_found, json: {}
      end
    end
  end
end
