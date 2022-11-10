require 'rails_helper'

describe 'Usuário tenta acessar funcionalidades sem estar logado' do 
  it 'e não consegue ir para a página de configurar meios de pagamento' do 
    get company_payment_options_url 

    expect(response).to redirect_to root_url
  end

  it 'e não consegue ir para a página de adicionar novo meio de pagamento para seguradora' do 
    get new_company_payment_option_url

    expect(response).to redirect_to root_url
  end
end