require 'rails_helper'

describe 'Usuário tenta acessar funcionalidades' do
  context 'sem estar autenticado' do
    it 'e vai para a página de opções de pagamento da seguradora' do
      get company_payment_options_path

      expect(response).to redirect_to root_path
    end

    it 'e vai para a página de configurar nova opção de pagamento da seguradora' do
      get new_company_payment_option_path

      expect(response).to redirect_to root_path
    end

    it 'e faz um POST para criar nova opção de pagamento' do
      params = { max_parcels: 2, single_parcel_discount: 1 }

      post company_payment_options_path, params: params

      expect(response).to redirect_to root_path
    end

    it 'e vai para a página de edição de uma opção de pagamento' do
      company = create(:insurance_company)
      user = create(:user, insurance_company_id: company.id,
                           name: 'Bruna de Paula', email: 'bruna@paolaseguros.com.br')
      payment_method = create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
      payment_option = create(
        :company_payment_option,
        user:,
        insurance_company: company,
        payment_method:,
        max_parcels: 12,
        single_parcel_discount: 0
      )

      get edit_company_payment_option_path(payment_option.id)

      expect(response).to redirect_to root_path
    end

    it 'e faz um UPDATE para a página de edição de uma opção de pagamento' do
      company = create(:insurance_company)
      user = create(:user, insurance_company_id: company.id,
                           name: 'Bruna de Paula', email: 'bruna@paolaseguros.com.br')
      payment_method = create(:payment_method, name: 'Cartão Nubank', payment_type: 'Cartão de Crédito')
      payment_option = create(
        :company_payment_option,
        user:,
        insurance_company: company,
        payment_method:,
        max_parcels: 12,
        single_parcel_discount: 0
      )
      params = { max_parcels: 3, single_parcel_discount: 1 }

      put company_payment_option_path(payment_option.id), params: params

      expect(response).to redirect_to root_path
    end

    it 'e tenta acessar a página de denúncias' do
      get fraud_reports_path

      expect(response).to redirect_to root_path
    end

    it 'e tenta acessar a página para criar uma nova denúncia' do
      get new_fraud_report_path

      expect(response).to redirect_to root_path
    end

    it 'e tenta fazer um POST para criar uma nova denúncia' do
      params = { fraud_report: {
        registration_number: '12345678911',
        insurance_company_id: 1,
        description: 'Ladrão!'
      } }

      post fraud_reports_path, params: params

      expect(response).to redirect_to root_path
      expect(FraudReport.count).to eq 0
    end

    it 'e tenta acessar a página de detalhes de uma denúncia' do
      company = create(:insurance_company)
      fraud = create(:fraud_report, insurance_company_id: company.id)

      get fraud_report_path(fraud.id)

      expect(response).to redirect_to root_path
    end
  end
end
