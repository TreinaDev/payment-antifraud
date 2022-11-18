require 'rails_helper'

RSpec.describe FraudReport, type: :model do
  describe '#valid' do 
    context 'presence' do 
      it 'falso quando CPF do cliente está em branco' do 
        company = FactoryBot.create(:insurance_company)
        fraud = FactoryBot.build(
                                  :fraud_report,
                                  registration_number: nil,
                                  description: 'Ladra Bandida!',
                                  insurance_company_id: company.id
        )
        fraud.images.attach(
                            [
                               Rack::Test::UploadedFile.new(Rails.root.join('spec/support/crime.jpeg')),
                               Rack::Test::UploadedFile.new(Rails.root.join('spec/support/fotos_do_crime.jpeg'))
                            ]
                           )

        fraud.save 

        expect(fraud).not_to be_valid 
        expect(fraud.errors.include?(:registration_number)).to be_truthy
      end

      it 'falso quando Descrição está em branco' do 
        company = FactoryBot.create(:insurance_company)
        fraud = FactoryBot.build(
                                  :fraud_report,
                                  registration_number: '12345678911',
                                  description: nil,
                                  insurance_company_id: company.id
        )
        fraud.images.attach(
                            [
                               Rack::Test::UploadedFile.new(Rails.root.join('spec/support/crime.jpeg')),
                               Rack::Test::UploadedFile.new(Rails.root.join('spec/support/fotos_do_crime.jpeg'))
                            ]
                           )

        fraud.save 

        expect(fraud).not_to be_valid 
        expect(fraud.errors.include?(:description)).to be_truthy
      end

      it 'falso quando Companhia de Seguros está em branco' do 
        company = FactoryBot.create(:insurance_company)
        fraud = FactoryBot.build(
                                  :fraud_report,
                                  registration_number: '12345678911',
                                  description: 'Ladra Bandida!',
                                  insurance_company_id: nil
        )
        fraud.images.attach(
                            [
                               Rack::Test::UploadedFile.new(Rails.root.join('spec/support/crime.jpeg')),
                               Rack::Test::UploadedFile.new(Rails.root.join('spec/support/fotos_do_crime.jpeg'))
                            ]
                           )

        expect(fraud).not_to be_valid
      end
    end
  end
end
