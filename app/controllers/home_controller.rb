class HomeController < ApplicationController
  def index
    begin     
      @insurance_companies_sample = get_insurance_companies_logos
    rescue    
    end
  end

  private

  def get_insurance_companies_logos
    insurance_url = "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies"
    response = Faraday.get(insurance_url)
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500
    data = JSON.parse(response.body)
    data.sample(4).map! { |d| {logo: d["logo_url"], name: d["name"]} }
  end
end
