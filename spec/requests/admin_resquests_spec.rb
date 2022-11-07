require 'rails_helper'
require 'support/api_shared_context_methods'

describe 'Usuaŕio comum tenta acessar as funcionalidades de um administrador' do
  context 'Lista de usuários' do
    include_context 'api_shared_context_methods'
    it 'e não consegue acessar a página' do
      user_registration_api_mock
      common_user = FactoryBot.create(:user, status: :approved)

      login_as common_user, scope: :user
      get users_path

      expect(response).to redirect_to root_path
    end

    it 'e não consegue acessar a página que aprova/recusa um cadastro' do
      user_registration_api_mock
      common_user = FactoryBot.create(:user, status: :approved)
      other_user = FactoryBot.create(:user, status: :pending)

      login_as common_user, scope: :user
      get new_user_user_approval_path(other_user.id)

      expect(response).to redirect_to root_path
    end
  end
end
