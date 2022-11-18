FactoryBot.define do
  factory :fraud_report do
    registration_number { '12345678911' }
    description { 'CALOTEIRO' }
    status { :pending }
    images { 
             [
                Rack::Test::UploadedFile.new(Rails.root.join('spec/support/crime.jpeg')),
                Rack::Test::UploadedFile.new(Rails.root.join('spec/support/fotos_do_crime.jpeg'))
             ] 
           }
  end
end
