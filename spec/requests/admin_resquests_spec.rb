require 'rails_helper'

describe 'Usuário comum tenta acessar as funcionalidades de um administrador' do
  context 'Lista de usuários' do
    it 'e não consegue acessar a página' do
      company = FactoryBot.create(:insurance_company)
      common_user = FactoryBot.create(:user, insurance_company_id: company.id, status: :approved)

      login_as common_user, scope: :user
      get users_path

      expect(response).to redirect_to root_path
    end

    it 'e não consegue acessar a página que aprova/recusa um cadastro' do
      company = FactoryBot.create(:insurance_company)
      target_user = FactoryBot.create(:user, insurance_company_id: company.id, status: :approved)
      other_user = FactoryBot.create(:user, insurance_company_id: company.id, status: :pending)

      login_as target_user, scope: :user
      get new_user_user_review_path(other_user.id)

      expect(response).to redirect_to root_path
    end

    it 'admin tenta acessar página de criar nova denúncia sem ter permissão' do
      admin = FactoryBot.create(:admin)

      login_as admin, scope: :admin
      get new_fraud_report_path

      expect(response).to redirect_to root_path
    end
  end
end
