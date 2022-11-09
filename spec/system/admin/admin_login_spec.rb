require 'rails_helper'

describe 'Admin tenta fazer login no sistema' do
  it 'e acessa a pagina de login diretamente pelo link' do
    visit new_admin_session_path

    expect(page).to have_content 'Login do Administrador'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Login'
  end

  it 'e faz login com sucesso' do
    FactoryBot.create(
      :admin, name: 'Petra Paola',
              email: 'petrapaola@email.com', password: '12345678'
    )

    visit new_admin_session_path

    fill_in 'E-mail', with: 'petrapaola@email.com'
    fill_in 'Senha', with: '12345678'
    click_on 'Login'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Olá Petra Paola - petrapaola@email.com'
    expect(page).to have_button 'Logout'
    expect(page).not_to have_button 'Fazer Login'
  end
end
