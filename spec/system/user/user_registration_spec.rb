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

  	visit root_path
  	within('nav') do
  	  click_on 'Fazer Login'
  	end
  	click_on 'Criar Conta'
  	within('div#signup-fields') do
  	  fill_in 'E-mail', with: 'petra@seguradoradapaola'
  	  fill_in 'Senha', with: 'password'
  	  fill_in 'Confirme sua senha', with: 'password'
  	  fill_in 'Nome', with: 'Petra'
  	  fill_in 'CPF', with: '39410293049'
  	  click_on 'Registrar'
  	end  
	
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end	
end