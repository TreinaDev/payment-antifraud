require 'rails_helper'

describe 'Usuário vê meios de pagamento' do
  it 'se estiver autenticado' do
    visit root_path
    within('nav') do
      click_on 'Meios de Pagamento'
    end

    expect(current_url).to eq root_url
    expect(page).to have_content 'Faça login para entrar'
  end

  it 'e está autenticado como funcionário da seguradora' do
    user = FactoryBot.create(:user, status: :approved)
    FactoryBot.create(:payment_method)
    FactoryBot.create(:payment_method, name: 'Roxo',
                                       tax_percentage: 3, tax_maximum: 50,
                                       payment_type: 'Boleto', status: :active)

    login_as(user, scope: :user)
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
  end

  it 'e está autenticado como administrador' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:payment_method)
    FactoryBot.create(:payment_method, name: 'Roxo',
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
  end

  it 'e não existem meios de pagamento cadastrados' do
    admin = FactoryBot.create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'

    expect(page).to have_content 'Não existem meios de pagamento cadastrados.'
  end
end
