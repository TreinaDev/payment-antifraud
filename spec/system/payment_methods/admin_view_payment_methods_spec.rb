require 'rails_helper'

describe 'Usuário vê meios de pagamento' do
  it 'se estiver autenticado' do
    visit payment_methods_path

    expect(current_url).to eq root_url
    expect(page).to have_content 'Acesso negado.'
  end

  it 'e está autenticado como administrador' do
    admin = create(:admin)
    create(:payment_method, name: 'Laranja',
                                       tax_percentage: 5, tax_maximum: 100,
                                       payment_type: 'Cartão de Crédito', status: :active)
    create(:payment_method, name: 'Roxo',
                                       tax_percentage: 3, tax_maximum: 50,
                                       payment_type: 'Boleto', status: :active)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'

    expect(current_url).to eq payment_methods_url
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Tipo de Pagamento'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Laranja'
    expect(page).to have_content 'Cartão de Crédito'
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'Roxo'
    expect(page).to have_content 'Boleto'
    within 'article footer #pagination' do
      expect(page).to have_content 'Primeira'
      expect(page).to have_content '< Anterior'
      expect(page).to have_content 'Página 1 de 1'
      expect(page).to have_content 'Próxima >'
      expect(page).to have_content 'Última'
    end
  end

  it 'e não existem meios de pagamento cadastrados' do
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'

    expect(page).to have_content 'Não existem meios de pagamento cadastrados.'
  end
end
