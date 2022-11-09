require 'rails_helper'

RSpec.describe UserReview, type: :model do
  describe '#valid?' do
    context '#validates_refusal_when_registration_is_approved_or_refused' do
      it 'falso quando o cadastro é recusado mas não tem motivo de reprovação preenchido' do
        user = FactoryBot.create(:user, status: :pending)

        user_review = UserReview.new(
          refusal: nil, status: :refused, user:
        )

        user_review.save

        expect(user_review).not_to be_valid
        expect(user_review.errors.include?(:refusal)).to be_truthy
        expect(user.status).to eq 'pending'
      end

      it 'falso quando o cadastro é aprovado e tem um motivo de reprovação preenchido' do
        user = FactoryBot.create(:user, status: :pending)

        user_review = UserReview.new(
          refusal: 'Não gostei de você', status: :approved, user:
        )

        user_review.save

        expect(user_review).not_to be_valid
        expect(user_review.errors.include?(:refusal)).to be_truthy
        expect(user.status).to eq 'pending'
      end

      it 'verdadeiro quando o cadastro é aprovado e não tem motivo de reprovação preenchido' do
        user = FactoryBot.create(:user, status: :pending)

        user_review = UserReview.new(
          refusal: nil, status: :approved, user:
        )

        expect(user_review).to be_valid
      end

      it 'verdadeiro quando o cadastro é recusado e tem um motivo preenchido' do
        user = FactoryBot.create(:user, status: :pending)

        user_review = UserReview.new(
          refusal: 'Você é feio!', status: :refused, user:
        )

        expect(user_review).to be_valid
      end
    end
  end
end
