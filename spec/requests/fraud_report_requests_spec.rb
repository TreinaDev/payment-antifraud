require 'rails_helper'

describe 'Usuário tenta acessar funcionalidades de denúncia de fraude' do
  context 'sem estar autenticado' do
    it 'e tenta acessar a tela que lista as denúncias de fraude' do
      get fraud_reports_path

      expect(response).to redirect_to root_path
    end

    it 'e tenta acessar a tela de detalhes de uma denúncia de fraude' do
      company = FactoryBot.create(:insurance_company)
      fraud = FactoryBot.create(:fraud_report, insurance_company_id: company.id)

      get fraud_report_path(fraud.id)

      expect(response).to redirect_to root_path
    end

    it 'e tenta aprovar uma denuncia de fraude' do
      company = FactoryBot.create(:insurance_company)
      fraud = FactoryBot.create(:fraud_report, insurance_company_id: company.id, status: :pending)

      post approves_fraud_report_path(fraud.id)

      expect(response).to redirect_to root_path
      expect(FraudReport.last.status).to eq 'pending'
    end

    it 'e tenta recusar uma denuncia de fraude' do
      company = FactoryBot.create(:insurance_company)
      fraud = FactoryBot.create(:fraud_report, insurance_company_id: company.id, status: :pending)

      post denies_fraud_report_path(fraud.id)

      expect(response).to redirect_to root_path
      expect(FraudReport.last.status).to eq 'pending'
    end
  end

  context 'autenticado como funcionário da seguradora' do
    it 'e tenta aprovar uma denuncia de fraude' do
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      fraud = FactoryBot.create(:fraud_report, insurance_company_id: company.id)

      login_as user, scope: :user
      post approves_fraud_report_path(fraud.id)

      expect(response).to redirect_to root_path
    end

    it 'e tenta recusar uma denuncia de fraude' do
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      fraud = FactoryBot.create(:fraud_report, insurance_company_id: company.id)

      login_as user, scope: :user
      post denies_fraud_report_path(fraud.id)

      expect(response).to redirect_to root_path
    end
  end

  context 'autenticado como admin' do
    it 'e tenta acessar a página do formulário para criar uma nova denuncia de fraude' do
      admin = FactoryBot.create(:admin)

      login_as admin, scope: :admin
      get new_fraud_report_path

      expect(response).to redirect_to root_path
    end

    it 'e tenta fazer um POST para criar uma nova denuncia de fraude' do
      admin = FactoryBot.create(:admin)
      params = {
        fraud_report: {
          description: 'Tentou fraudar o sistema',
          registration_number: '12345678911'
        }
      }

      login_as admin, scope: :admin
      post fraud_reports_path, params: params

      expect(response).to redirect_to root_path
    end
  end
end
