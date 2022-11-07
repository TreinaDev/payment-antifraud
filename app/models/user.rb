require 'json'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { pending: 0, approved: 1, refused: 2 }
  has_one :user_approval, dependent: :destroy
  before_save :consult_insurance_company_api

  private 

  def domain
    self.email.split('@').last
  end

  def consult_insurance_company_api 
    response = Faraday.get('http://localhost:3000/insurance_companies/')
    json_data = JSON.parse(response.body)
    data_list = parse_json_data(json_data)

    data_list.each do |company|
      return unless company.include? self.domain && company[1] == 0 && company[2] == 0   
      errors.add(:email, "deve pertencer a uma seguradora ativa.")  
    end 
  end

  def parse_json_data(data)
    data.map  do |company| 
      [
        company["email_domain"],
        company["company_status"],
        company["token_status"]
      ]
    end
  end 

end
