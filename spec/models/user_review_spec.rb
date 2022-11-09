require 'rails_helper'

RSpec.describe UserReview, type: :model do
  describe '#valid?' do
    context '#validates_refusal_when_registration_is_approved_or_refused' do
      it 'falso quando o cadastro é recusado mas não tem motivo preenchido' do
        user = FactoryBot.create(:user, status: :pending)

        user_review = UserReview.new(
          refusal: nil, status: :refused, user: user 
        )

        user_review.save

        expect(user_review.errors.include?(:refusal)).to be_truthy
        expect(user.status).to eq 'pending'
      end
    end
  end
end
