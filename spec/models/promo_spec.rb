require 'rails_helper'

RSpec.describe Promo, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      promo = build(:promo)
      result = promo.valid?

      expect(result).to be(true)
    end

    it 'a data final deve ser maior que a inicial' do
      promo = build(:promo, starting_date: Time.zone.today, ending_date: (Time.zone.today + 7.days))
      result = promo.valid?

      expect(result).to be true
    end

    it 'a data final não pode ser vazia' do
      promo = build(:promo, starting_date: '2022-12-03', ending_date: '')
      result = promo.valid?

      expect(result).to be false
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
