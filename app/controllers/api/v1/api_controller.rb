module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error_status
      rescue_from ActiveRecord::RecordNotFound, with: :not_found_status

      private

      def internal_server_error_status
        render status: :internal_server_error
      end

      def not_found_status
        render status: :not_found, json: { error: "#{self.class.to_s.split(':').last.gsub('Controller', '')[0...-1]} not found" }
      end
    end
  end
end
