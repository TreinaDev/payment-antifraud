class ProductsApi
  attr_accessor :id, :product_model, :status

  def initialize(id:, product_model:, status:)
    @id = id
    @product_model = product_model
    @status = status

  end

  def self.new_product(params)
    ProductsApi.new(
      id: params['id'],
      product_model: params['product_model'],
      status: params['status']
    )
  end

  def self.all
    products_url = Rails.configuration["external_apis"].insurance_api_products_endpoint
    response = Faraday.get(products_url)
    return [] if response.status == 204
    raise ActiveRecord::QueryCanceled if response.status == 500

    data = JSON.parse(response.body)
    data.map { |d| new_product(d) }
  end

  def self.products_array
    all.map { |product| [product[:name], product[:id]]}
  end
end
