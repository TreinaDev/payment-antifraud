require 'rails_helper'

describe 'Usuaŕio comum tenta acessar as funcionalidades de um administrador' do 
  context 'Lista de usuários' do 
    it 'e não consegue acessar a página' do 
      common_user = FactoryBot.create(:user, status: :approved)

      login_as common_user, scope: :user
      get registered_users_home_index_path

      expect(response).to redirect_to root_path 
    end

    it 'e não consegue acessar a página que aprova/recusa um cadastro' do 
      common_user = FactoryBot.create(:user, status: :approved)
      other_user = FactoryBot.create(:user, status: :pending)

      login_as common_user, scope: :user
      get new_user_user_approval_path(other_user.id)

      expect(response).to redirect_to root_path
    end
  end

end