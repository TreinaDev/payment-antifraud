require 'rails_helper'

describe 'Administrador vê a lista de usuários cadastrados' do
  it 'se estiver autenticado' do
    common_user = FactoryBot.create(:user)

    visit root_path

    expect(page).not_to have_link 'Usuários'
  end

  context 'a partir de uma tela separada' do
    it 'com sucesso' do
      admin = FactoryBot.create(:admin)
      FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending
      )

      FactoryBot.create(
        :user, name: 'Petra', email: 'petra@paolaseguros.com.br',
               registration_number: '12345678911', status: :approved
      )

      login_as admin, scope: :admin
      visit root_path
      click_on 'Usuários'

      expect(page).to have_content 'Lista de Usuários'
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'Status do cadastro'
      expect(page).to have_content 'Paola'
      expect(page).to have_content 'paola@petraseguros.com.br'
      expect(page).to have_content '39401920391'
      expect(page).to have_content 'Cadastro pendente'
      expect(page).to have_content 'Petra'
      expect(page).to have_content 'petra@paolaseguros.com.br'
      expect(page).to have_content '12345678911'
      expect(page).to have_content 'Cadastro aprovado'
    end
  end

  context 'e vê botão de alteração de cadastro' do
    it 'de um usuário pendente' do
      admin = FactoryBot.create(:admin)
      FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending
      )

      login_as admin, scope: :admin
      visit registered_users_home_index_path

      expect(page).to have_link 'Avaliar Cadastro'
    end

    it 'e não vê botão caso o usuário já esteja aprovado' do
      admin = FactoryBot.create(:admin)
      FactoryBot.create(
        :user, name: 'Petra APROVADA', email: 'petraaprovada@paolaseguros.com.br',
               registration_number: '39401920391', status: :approved
      )

      login_as admin, scope: :admin
      visit registered_users_home_index_path

      expect(page).to have_content 'Petra APROVADA'
      expect(page).not_to have_link 'Avaliar Cadastro'
    end
  end

  context 'e muda o status do cadastro' do
    it 'a partir de um formulário' do
      admin = FactoryBot.create(:admin)
      FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending
      )

      login_as admin, scope: :admin
      visit registered_users_home_index_path
      click_on 'Avaliar Cadastro'

      expect(page).to have_content 'Aprovar Cadastro?'
      expect(page).to have_content 'Sim'
      expect(page).to have_content 'Não'
      expect(page).to have_field 'Motivo de reprovação'
      expect(page).to have_button 'Enviar'
    end

    it 'para aprovado' do
      admin = FactoryBot.create(:admin)
      common_user = FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending
      )

      login_as admin, scope: :admin
      visit new_user_user_approval_path(common_user.id)
      choose 'user_approval_status_true', allow_label_click: true
      click_on 'Enviar'

      expect(page).to have_content 'Usuário aprovado com sucesso.'
      expect(page).to have_content 'Paola'
      expect(page).to have_content 'paola@petraseguros.com.br'
      expect(page).to have_content 'Cadastro aprovado'
    end

    it 'para recusado' do
      admin = FactoryBot.create(:admin)
      common_user = FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending
      )

      login_as admin, scope: :admin
      visit new_user_user_approval_path(common_user.id)
      choose 'user_approval_status_false', allow_label_click: true
      fill_in 'Motivo de reprovação', with: 'Hacker invadindo o sistemaa!'
      click_on 'Enviar'

      expect(page).to have_content 'Usuário reprovado com sucesso.'
      expect(page).to have_content 'Paola'
      expect(page).to have_content 'paola@petraseguros.com.br'
      expect(page).to have_content 'Cadastro recusado'
    end

    it 'e não preenche a reprovação com uma justificativa' do
      admin = FactoryBot.create(:admin)
      common_user = FactoryBot.create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending
      )

      login_as admin, scope: :admin
      visit new_user_user_approval_path(common_user.id)
      choose 'user_approval_status_false', allow_label_click: true
      fill_in 'Motivo de reprovação', with: ''
      click_on 'Enviar'

      expect(page).to have_content 'Motivo de reprovação deve ser preenchido para recusar o cadastro.'
    end
  end
end
