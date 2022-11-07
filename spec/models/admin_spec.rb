require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'presence' do
    describe 'Usuário tenta fazer cadastro com parametro em branco' do
      it 'Nome' do
        admin = FactoryBot.build(:admin, name: nil)

        admin.save

        expect(admin.errors.include?(:name)).to be_truthy
        expect(admin).not_to be_valid
      end
    end
  end
end
