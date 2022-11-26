require 'rails_helper'

describe 'Usuaŕio tenta modificar dados de produtos de uma promoção' do
  context 'e não está autenticado' do
    it 'tenta adicionar um produto a uma promoção' do
      company = create(:insurance_company)
      my_promo = create(:promo, insurance_company_id: company.id)

      post(promo_promo_products_url(my_promo), params: { promo_product: { id: 3, product_id: 5, promo: my_promo } })

      expect(response).to redirect_to root_path
    end
    it 'tenta remover um produto de uma promoção' do
      company = create(:insurance_company)
      my_promo = create(:promo, insurance_company_id: company.id)
      promo_product = create(:promo_product, promo: my_promo)

      delete(promo_promo_product_url(my_promo, promo_product),
             params: { promo_product: { id: 3, product_id: 5, promo: my_promo } })

      expect(response).to redirect_to root_path
    end
  end
end
