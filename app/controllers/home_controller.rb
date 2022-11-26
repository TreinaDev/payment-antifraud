class HomeController < ApplicationController
  def index
    @insurance_companies_sample = insurance_companies_logos
  end

  private

  def insurance_companies_logos
    insurance_url = "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies"
    response = Faraday.get(insurance_url)
    return [] if response.status == 204 || response.status == 500

    data = JSON.parse(response.body)
    data.sample(4).map! { |d| { logo: d['logo_url'], name: d['name'] } }
  end
end
