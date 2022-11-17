require 'rails_helper'

describe 'Funcionário faz login no sistema' do
  it 'a partir de um formulário' do
    visit root_path
    within 'nav' do
      click_on 'Fazer Login'
    end

    expect(page).to have_content 'Login do funcionário da seguradora'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Login'
  end

  it 'se estiver com seu cadastro aprovado' do
    company = FactoryBot.create(:insurance_company)
    FactoryBot.create(:user,
                      email: 'petra@paolaseguros.com.br',
                      password: 'password',
                      name: 'Petra',
                      registration_number: '39401929301',
                      status: :approved,
                      insurance_company_id: company.id)

    visit new_user_session_path
    within('div#login-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Login'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Olá Petra - petra@paolaseguros.com.br'
    expect(page).to have_button 'Logout'
    expect(page).not_to have_link 'Fazer Login'
  end

  it 'e está com o cadastro aguardando aprovação' do
    company = FactoryBot.create(:insurance_company)
    FactoryBot.create(:user,
                      email: 'edicleia@paolaseguros.com.br',
                      password: 'password',
                      name: 'Edicleia',
                      registration_number: '39401929301',
                      status: :pending,
                      insurance_company_id: company.id)

    visit new_user_session_path
    within('div#login-fields') do
      fill_in 'E-mail', with: 'edicleia@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Login'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Sua conta ainda não foi aprovada por um administrador.'
  end

  it 'e não preenche todos os campos' do
    company = FactoryBot.create(:insurance_company)
    FactoryBot.create(:user,
                      email: 'petra@paolaseguros.com.br',
                      password: 'password',
                      name: 'Petra',
                      registration_number: '39401929301',
                      status: :approved,
                      insurance_company_id: company.id)

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
