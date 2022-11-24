class Invoice < ApplicationRecord
  enum status: { pending: 0, approved: 5, refused: 10 }
  before_validation :generate_token, on: :create
  belongs_to :payment_method
  belongs_to :insurance_company

  validates :parcels, :total_price, :package_id, :order_id, presence: true
  validate :valid_insurance_company?
  validate :check_payment_method_options, if: :valid_insurance_company?
  validates :transaction_registration_number, presence: true, on: :update, if: :approved?
  validates :reason_for_failure, presence: true, on: :update, if: :refused?

  before_validation :generate_token, on: :create

<<<<<<< HEAD
  def name_insurance_company
    response = Faraday
               .get("#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/#{insurance_company_id}")
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

=======
  def get_insurance_company_id
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/#{insurance_company_id}")
>>>>>>> 078492fcb6fd3d01ac07044577c0f6cec6a39989
    data = JSON.parse(response.body)
    data['name']
  end

<<<<<<< HEAD
  def name_package
    response = Faraday
               .get("#{Rails.configuration.external_apis['insurance_api']}/packages/#{package_id}")
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

=======
  def get_package_id
    response = Faraday.get("#{Rails.configuration.external_apis['insurance_api']}/packages/#{package_id}")
>>>>>>> 078492fcb6fd3d01ac07044577c0f6cec6a39989
    data = JSON.parse(response.body)
    data['name']
  end

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end

  def check_payment_method_options
    return if insurance_company.payment_options.map(&:payment_method).include?(payment_method)

    errors.add(:payment_method, 'deve ter meio de pagamento escolhido por seguradora')
  end

  def valid_insurance_company?
    return true if InsuranceCompany.find_by(external_insurance_company: insurance_company_id)

    false
  end
end
