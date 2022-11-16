require 'rails_helper'

describe Api::V1::InvoicesController, type: :request do
  describe 'POST#create api/v1/invoices' do
    context 'when is successful' do
      it 'return 201 and invoice attributes as JSON' do
        insurance_company = create(:insurance_company)
        user = create(:user, insurance_company:)
        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('A1S2D3F4G5H6J7K8L9ZA')
        payment_method = create(:payment_method)
        create(:company_payment_option,
               user:,
               insurance_company:,
               payment_method:,
               max_parcels: 10,
               single_parcel_discount: 5)
        params = {
          invoice: {
            payment_method_id: payment_method.id,
            order_id: 1, registration_number: '12345678', status: 0,
            package_id: 1, insurance_company_id: insurance_company.id
          }
        }

        post '/api/v1/invoices', params: params

        expect(response).to have_http_status :created
        expect(response_parsed).to include({
          payment_method_id: payment_method.id,
          token: 'A1S2D3F4G5H6J7K8L9ZA',
          order_id: 1,
          registration_number: '12345678',
          status: 'pending',
          package_id: 1,
          insurance_company_id: insurance_company.id
        }.with_indifferent_access)
      end

      it 'creates a new invoice' do
        insurance_company = create(:insurance_company)
        user = create(:user, insurance_company:)
        payment_method = create(:payment_method)
        create(:company_payment_option,
               user:,
               insurance_company:,
               payment_method:,
               max_parcels: 10,
               single_parcel_discount: 5)

        params = {
          invoice: { payment_method_id: payment_method.id,
                     order_id: 1, registration_number: '12345678', status: 0,
                     package_id: 1, insurance_company_id: insurance_company.id }
        }

        expect { post '/api/v1/invoices', params: }.to change { Invoice.count }.from(0).to(1)
      end
    end

    context 'when fails' do
      it 'return 412 and invoice errors as JSON' do
        payment_method = create(:payment_method)
        company = create(:insurance_company)
        user = create(:user, insurance_company: company)
        company_payment_option = FactoryBot.create(:company_payment_option, insurance_company_id: company.id, payment_method_id: payment_method.id, user: user)

        params = { invoice: { insurance_company_id: company.id, payment_method_id: nil } }

        post '/api/v1/invoices', params: params

        expect(response).to have_http_status :precondition_failed
        expect(response_parsed['errors']).not_to be_empty
      end

      it 'does not creates a new invoice' do
        payment_method = create(:payment_method)
        company = create(:insurance_company)
        user = create(:user, insurance_company: company)
        company_payment_option = FactoryBot.create(:company_payment_option, insurance_company_id: company.id, payment_method_id: payment_method.id, user: user)

        params = { invoice: { insurance_company_id: company.id, payment_method_id: nil } }

        expect { post '/api/v1/invoices', params: }.not_to(change { Invoice.count })
      end
    end
  end

  describe 'GET#index api/v1/invoices' do
    context 'when is successful' do
      it 'list all invoices ' do
        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('A1S2D3F4G5H6J7K8L9ZA')
        allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('S2D3F4G5')
        payment_method = create(:payment_method)
        insurance_company = create(:insurance_company)
        user = create(:user, insurance_company: insurance_company)
        company_payment_option = FactoryBot.create(:company_payment_option, insurance_company_id: insurance_company.id, payment_method_id: payment_method.id, user: user)

        invoice = Invoice.create!(payment_method:,
                                  order_id: 1, registration_number: '12345678', status: 0,
                                  package_id: 1, insurance_company_id: insurance_company.id)
        second_invoice = Invoice.create!(payment_method:,
                                         order_id: 2, registration_number: '87654321', status: 0,
                                         package_id: 2, insurance_company_id: insurance_company.id)

        get '/api/v1/invoices'

        expect(response).to have_http_status 200
        expect(response_parsed).to match([second_invoice.as_json, invoice.as_json])
      end

      it 'return empty if there is no invoices' do
        get '/api/v1/invoices'

        expect(response).to have_http_status 200
        expect(response_parsed).to eq []
      end
    end
  end

  describe 'GET#show api/v1/invoices/' do
    context 'when is successful' do
      it 'success' do
        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('A1S2D3F4G5H6J7K8L9ZA')
        allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('S2D3F4G5')
        payment_method = create(:payment_method)
        insurance_company = create(:insurance_company)
        user = create(:user, insurance_company: insurance_company)
        company_payment_option = FactoryBot.create(:company_payment_option, insurance_company_id: insurance_company.id, payment_method_id: payment_method.id, user: user)
        invoice = Invoice.create!(payment_method:,
                                  order_id: 1, registration_number: '12345678', status: 0,
                                  package_id: 1, insurance_company_id: insurance_company.id)

        get "/api/v1/invoices/#{invoice.id}"

        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')
        expect(response_parsed['order_id']).to eq(1)
        expect(response_parsed['registration_number']).to eq('12345678')
        expect(response_parsed['package_id']).to eq(1)
      end
    end
    context 'when is fails' do
      it 'fail if invoice not found' do
        get '/api/v1/invoices/9999'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
