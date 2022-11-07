require 'rails_helper'
require 'support/api_shared_context_methods'

describe 'Funcionário faz login no sistema' do
  include_context 'api_shared_context_methods'

  it 'com sucesso' do
    user_registration_api_mock
    FactoryBot.create(:user,
                      email: 'petra@paolaseguros.com.br',
                      password: 'password',
                      name: 'Petra',
                      registration_number: '39401929301',
                      status: :pending)

    visit root_path
    within('nav') do
      click_on 'Fazer Login'
    end
    within('div#login-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Login'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Olá Petra - petra@paolaseguros.com.br'
    expect(page).to have_button 'Logout'
    expect(page).not_to have_link 'Fazer Login'
    expect(page).to have_content 'Aguardando aprovação do administrador do sistema.'
  end

  it 'e não preenche todos os campos' do
    user_registration_api_mock
    FactoryBot.create(:user,
                      email: 'petra@paolaseguros.com.br',
                      password: 'password',
                      name: 'Petra',
                      registration_number: '39401929301',
                      status: :pending)

    visit root_path

    within('nav') do
      click_on 'Fazer Login'
    end
    within('div#login-fields') do
      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''
      click_on 'Login'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
  end
end
