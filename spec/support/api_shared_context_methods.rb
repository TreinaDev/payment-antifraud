RSpec.shared_context 'api_shared_context_methods' do
  def user_registration_api_mock
    json_data = File.read Rails.root.join('spec/support/json/insurance_companies.json')
    fake_response = double('Faraday::Response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/insurance_companies/').and_return(fake_response)
  end
end
