require 'rails_helper' 
describe "invoice" do
  it '#' do
    invoice = Invoice.create(order_id: 1 , registration_number: '12345678', status: 0,
      package_id: 1, insurance_company_id: 10)
    params = {
      invoice: {
        order_id: 1 , registration_number: '12345678', status: 0,
        package_id: 1, insurance_company_id: 10}
      }
    fake_response = double('fake_response', status: 201, body: invoice.as_json)
    allow(Api::V1::InvoicesController).to receive(:create).and_return(fake_response)
    post "/api/v1/invoices", params: params 
    
    expect(response).to have_http_status 201  
    
    binding.b
    expect(response).to   
  end
end
