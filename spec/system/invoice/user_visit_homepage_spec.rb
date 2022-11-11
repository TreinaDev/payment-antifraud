require 'rails_helper' 

describe "Usuário visita" do
  it 'e vê faturas' do
    invoices = []
    invoices << Invoice.new(order_id: 1, status: 0,
                            insurance_company_id: 1,
                            package_id: 1,
                            registration_number: '12345678' )
    invoices << Invoice.new(order_id: 2, status: 0,
                            insurance_company_id: 2,
                            package_id: 2,
                            registration_number: '12345678' )

    allow(Invoice).to receive(:all).and_return(invoices)

    visit root_path

    expect(page).to have_content 'registration_number: 12345678'

  end
end
