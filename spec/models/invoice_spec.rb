require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Gera um código aleatório' do
    it 'ao criar um uma cobrança' do
      payment_method = create(:payment_method)
      invoice = build(:invoice, payment_method: payment_method)


      invoice.save!
      result = invoice.token

      expect(result).not_to be_empty
      expect(result.length).to eq 20
    end

    it 'e o código é único' do
      payment_method = create(:payment_method)
      invoice_a = create(:invoice, payment_method: payment_method)
      invoice_b = create(:invoice, payment_method: payment_method)

      result = invoice_a.token
      expect(invoice_b.token).not_to eq result
    end
  end
end
