module ParseResponse
  def response_parsed
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ParseResponse
end
