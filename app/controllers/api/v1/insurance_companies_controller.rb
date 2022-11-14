module Api
  module V1
    class InsuranceCompaniesController < Api::V1::ApiController
      def payment_options
        company = InsuranceCompany.find_by(external_insurance_company: params[:id])
        if company.present?
          return render status: :ok, json: create_json_response(company),
                        except: %i[created_at updated_at]
        end

        raise ActiveRecord::RecordNotFound
      end

      private

      def create_json_response(company)
        company.payment_options.map do |po|
          {
            name: po.payment_method.name,
            payment_type: po.payment_method.payment_type,
            tax_percentage: po.payment_method.tax_percentage,
            tax_maximum: po.payment_method.tax_maximum,
            max_parcels: po.max_parcels,
            single_parcel_discount: po.single_parcel_discount
          }
        end
      end
    end
  end
end
