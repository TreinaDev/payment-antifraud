require 'rails_helper'

RSpec.describe Promo, type: :model do

  describe '#valid?' do

    it 'deve ter um código' do
      promo = build(:promo) 
      result = promo.valid?
      
      expect(result).to be true 
    end
  end

  describe 'Gera um código aleatório' do

    it 'ao criar uma nova promoção' do
      promo = build(:promo)

      promo.save!
      result = promo.voucher

      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'e o código é único' do
      promo_a = create(:promo)
      promo_b = create(:promo)
 
      result = promo_a.voucher
      expect(promo_b.voucher).not_to eq result  
    end
  end
end
