require 'rails_helper'

RSpec.describe UserApproval, type: :model do
  describe '#valid?' do
    context '#ensure_refusal_when_registration_is_refused' do
      it 'falso quando o cadastro é recusado mas não tem motivo preenchido' do
        user = FactoryBot.create(:user, status: :pending)

        user_approval = UserApproval.new(
          refusal: nil, status: false,
          user:
        )

        user_approval.save

        expect(user_approval.errors.include?(:refusal)).to be_truthy
        expect(user.status).to eq 'pending'
      end
    end
  end
end
