require 'rails_helper'
require 'support/api_shared_context_methods'

RSpec.describe UserApproval, type: :model do
  describe '#valid?' do
    include_context 'api_shared_context_methods'
    context '#ensure_refusal_when_registration_is_refused' do
      it 'falso quando o cadastro é recusado mas não tem motivo preenchido' do
        user_registration_api_mock
        user = FactoryBot.create(:user, status: :pending)

        user_approval = UserApproval.new(
          refusal: nil, status: false, user:
        )

        user_approval.save

        expect(user_approval.errors.include?(:refusal)).to be_truthy
        expect(user.status).to eq 'pending'
      end
    end
  end
end
