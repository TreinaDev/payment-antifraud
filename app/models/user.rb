require 'json'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1, refused: 2 }
  has_one :user_approval, dependent: :destroy
  before_validation :consult_insurance_company_api_for_email_validation

  private

  def domain
    email.split('@').last
  end

  def consult_insurance_company_api_for_email_validation
    response = Faraday.get('http://localhost:3000/insurance_companies/')
    if response.status == 200
      json_data = JSON.parse(response.body)
      data_list = parse_json_data(json_data)
      data_list.each do |company|
        if (company.include? domain) 
          if company[1] == 0 && company[2] == 0
            return 
          else  
            errors.add(:email, 'deve pertencer a uma seguradora ativa.')
          end
        end
      end
    elsif response.status == 500
      raise ActiveRecord::QueryCanceled
    end
    errors.add(:email, 'deve pertencer a uma seguradora ativa.')
  end

  def parse_json_data(data)
    data.map do |company|
      [
        company['email_domain'],
        company['company_status'],
        company['token_status']
      ]
    end
  end
end
