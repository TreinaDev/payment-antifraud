require 'rails_helper'

describe Api::V1::InvoicesController, type: :request do
  describe 'POST#create api/v1/invoices' do
    context 'when is successful' do
      it 'return 201 and invoice attributes as JSON' do
        allow(SecureRandom).to receive(:alphanumeric).with(20).and_return('A1S2D3F4G5H6J7K8L9ZA')
        params = {
          invoice: {
            order_id: 1, registration_number: '12345678', status: 0,
            package_id: 1, insurance_company_id: 10
          }
        }

        post '/api/v1/invoices', params: params

        expect(response).to have_http_status :created
        expect(response_parsed).to include(
          token: 'A1S2D3F4G5H6J7K8L9ZA',
          order_id: 1,
          registration_number: '12345678',
          status: 'pending',
          package_id: 1,
          insurance_company_id: 10
        )
      end

      it 'creates a new invoice' do
        params = {
          invoice: {
            order_id: 1, registration_number: '12345678', status: 0,
            package_id: 1, insurance_company_id: 10
          }
        }

        expect { post '/api/v1/invoices', params: }.to change { Invoice.count }.from(0).to(1)
      end
    end

    context 'when fails' do
      it 'return 412 and invoice errors as JSON' do
        params = { invoice: { insurance_company_id: nil } }

        post '/api/v1/invoices', params: params

        expect(response).to have_http_status :precondition_failed
        expect(response_parsed[:errors]).not_to be_empty
      end

      it 'does not creates a new invoice' do
        params = { invoice: { insurance_company_id: nil } }

        expect { post '/api/v1/invoices', params: }.not_to(change { Invoice.count })
      end
    end
  end
end
