require 'rails_helper'

describe 'Funcionário faz cadastro no sistema' do
  it 'a partir de um formulário' do
    visit root_path
    click_on 'Fazer Login'
    click_on 'Criar Conta'

    expect(page).to have_field 'Nome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_field 'CPF'
    expect(page).to have_button 'Registrar'
  end

  it 'com sucesso' do
    allow(InsuranceCompany).to receive(:user_email_match_any_company?).and_return(true)

    visit root_path
    within('nav') do
      click_on 'Fazer Login'
    end
    click_on 'Criar Conta'
    within('div#signup-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'Nome', with: 'Petra'
      fill_in 'CPF', with: '39410293049'
      click_on 'Registrar'
    end

    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end

  it 'e não há seguradoras cadastradas' do
    fake_response = double('Faraday::Response', status: 204, body: {}.to_json)
    allow(Faraday).to receive(:get).with('http://localhost:3000/insurance_companies/').and_return(fake_response)

    visit root_path
    within('nav') do
      click_on 'Fazer Login'
    end
    click_on 'Criar Conta'
    within('div#signup-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'Nome', with: 'Petra'
      fill_in 'CPF', with: '39410293049'
      click_on 'Registrar'
    end

    expect(page).to have_content 'E-mail deve pertencer a uma seguradora ativa.'
  end

  it 'e o sistema de seguradoras está fora do ar' do
    fake_response = double('Faraday::Response', status: 500, body: {}.to_json)
    allow(Faraday).to receive(:get).with('http://localhost:3000/insurance_companies/').and_return(fake_response)

    visit root_path
    within('nav') do
      click_on 'Fazer Login'
    end
    click_on 'Criar Conta'
    within('div#signup-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'Nome', with: 'Petra'
      fill_in 'CPF', with: '39410293049'
      click_on 'Registrar'
    end

    expect(page).to have_content 'Erro de servidor. Por favor tente novamente mais tarde.'
  end

  it 'e não há seguradoras que correspondem ao e-mail do usuário' do
    allow(InsuranceCompany).to receive(:user_email_match_any_company?).and_return(false)

    visit root_path
    within('nav') do
      click_on 'Fazer Login'
    end
    click_on 'Criar Conta'
    within('div#signup-fields') do
      fill_in 'E-mail', with: 'petra@SEGURADORAQUENAOEXISTEGLUGLUGLUGLU.COM.BR'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'Nome', with: 'Petra'
      fill_in 'CPF', with: '39410293049'
      click_on 'Registrar'
    end

    expect(page).to have_content 'E-mail deve pertencer a uma seguradora ativa.'
  end

  it 'e as seguradoras existem mas não estão ativas' do
    allow(InsuranceCompany).to receive(:user_email_match_any_company?).and_return(false)

    visit root_path
    within('nav') do
      click_on 'Fazer Login'
    end
    click_on 'Criar Conta'
    within('div#signup-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'Nome', with: 'Petra'
      fill_in 'CPF', with: '39410293049'
      click_on 'Registrar'
    end

    expect(page).to have_content 'E-mail deve pertencer a uma seguradora ativa.'
  end
end
