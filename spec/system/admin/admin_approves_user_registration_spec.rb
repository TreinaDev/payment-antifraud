require 'rails_helper'

describe 'Administrador aprova o cadastro de um usuário' do 
  it 'a partir de uma tela separada' do 
    admin = FactoryBot.create(:admin)
    FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
                    registration_number: '39401920391', status: :pending
      )

    login_as admin, scope: :admin
    visit root_path
    click_on 'Usuários'

    expect(page).to have_content 'Usuários Pendentes'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'CPF'
    expect(page).to have_content 'Status do cadastro'
    expect(page).to have_content 'Paola'
    expect(page).to have_content 'paola@petraseguros.com.br'
    expect(page).to have_content '39401920391'
    expect(page).to have_content 'Cadastro pendente'
    expect(page).to have_content 'Usuários Ativos'
  end
end