require 'rails_helper'

RSpec.describe PromoProduct, type: :model do
  context '#valid?' do
    describe 'uniqueness' do
      it 'e o produto só pode ser adicionado uma única vez em uma promoção' do
        company = create(:insurance_company)
        promo1 = create(:promo, insurance_company_id: company.id)
        promo2 = create(:promo, insurance_company_id: company.id)
        create(:promo_product, product_id: 1, promo: promo1)
        create(:promo_product, product_id: 1, promo: promo2)
        test_product = build(:promo_product, product_id: 1, promo: promo1)

        result = test_product.valid?

        expect(result).to eq false
        expect(test_product.errors.include?(:product_id)).to eq true
      end
    end
  end
end
