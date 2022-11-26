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
    company = ExternalInsuranceCompany.new(
      id: 1,
      email_domain: '@paolaseguros.com.br',
      company_status: 0,
      company_token: 'TOKENEXPIRADODESDE1999',
      token_status: 0
    )
    fake_response = double('Faraday::Response', status: 200, body: company.to_json)
    allow(Faraday)
      .to receive(:get)
      .with(
        "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/query",
        { id: 'petra@paolaseguros.com.br' }
      )
      .and_return(fake_response)
    

    visit new_user_session_path
    click_on 'Criar Conta'
    within('div#signup-fields') do
      fill_in 'E-mail', with: 'petra@paolaseguros.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'Nome', with: 'Petra'
      fill_in 'CPF', with: '39410293049'
      click_on 'Registrar'
      allow(Faraday).to receive(:get).with(Rails.configuration.external_apis['insurance_api']).and_return([])
    end

    expect(page).to have_content 'Você se inscreveu com sucesso. ' \
                                 'Por favor aguarde um administrador aprovar seu cadastro antes de fazer login.'
    expect(User.count).to eq 1
  end

  it 'e não há seguradoras cadastradas na aplicação de seguradoras' do
    fake_response = double('Faraday::Response', status: 404)
    allow(Faraday).to receive(:get).and_return(fake_response)

    visit new_user_session_path
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
    expect(User.count).to eq 0
  end

  it 'e o sistema de seguradoras está fora do ar' do
    fake_response = double('Faraday::Response', status: 500)
    allow(Faraday).to receive(:get).and_return(fake_response)

    visit new_user_session_path
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
    expect(User.count).to eq 0
  end

  it 'e não há seguradoras que correspondem ao e-mail do usuário' do
    fake_response = double('Faraday::Response', status: 404)
    allow(Faraday).to receive(:get).and_return(fake_response)

    visit new_user_session_path
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
    expect(User.count).to eq 0
  end

  it 'e as seguradoras existem mas não estão ativas' do
    ExternalInsuranceCompany.new(
      id: 1,
      email_domain: 'petra@paolaseguros.com.br',
      company_status: 1,
      company_token: 'TOKENEXPIRADODESDE1999',
      token_status: 1
    )
    fake_response = double('Faraday::Response', status: 404)
    allow(Faraday)
      .to receive(:get)
      .with(
        "#{Rails.configuration.external_apis['insurance_api']}/insurance_companies/query",
        { id: 'petra@paolaseguros.com.br' }
      )
      .and_return(fake_response)

    visit new_user_session_path
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
    expect(User.count).to eq 0
  end
end
