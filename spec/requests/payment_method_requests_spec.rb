require 'rails_helper'

describe 'Usuaŕio funcionário da seguradora tenta acessar as funcionalidades de um administrador' do
  context 'Meios de Pagamentos' do
    it 'e não consegue acessar a página' do
      company = FactoryBot.create(:insurance_company)
      FactoryBot.create(:user, status: :approved, insurance_company_id: company.id)

      get payment_methods_path

      expect(response).to redirect_to root_path
    end
  end
end

describe 'Usuário comum tenta acessar as funcionalidades de um administrador' do
  context 'Meios de Pagamentos' do
    it 'e não consegue acessar a página' do
      get payment_methods_path

      expect(response).to redirect_to root_path
    end
  end
end
