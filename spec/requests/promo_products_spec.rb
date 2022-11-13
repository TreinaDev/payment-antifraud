require 'rails_helper'

describe 'Usuaŕio tenta modificar dados de produtos de uma promoção' do
  context 'e não está autenticado' do
    it 'tenta adicionar um produto a uma promoção' do
      my_promo = FactoryBot.create(:promo)

      post(promo_promo_products_url(my_promo), params: { promo_product: { id: 3, product_id: 5, promo: my_promo } })

      expect(response).to redirect_to root_path
    end
    it 'tenta remover um produto a uma promoção' do
      my_promo = FactoryBot.create(:promo)
      promo_product = FactoryBot.create(:promo_product, promo: my_promo)

      delete(promo_promo_product_url(my_promo, promo_product),
             params: { promo_product: { id: 3, product_id: 5, promo: my_promo } })

      expect(response).to redirect_to root_path
    end
  end
end
