module ParseResponse
  def response_parsed
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ParseResponse
end
