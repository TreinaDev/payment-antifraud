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
  end
end
