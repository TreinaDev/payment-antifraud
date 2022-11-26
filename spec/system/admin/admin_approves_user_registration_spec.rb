require 'rails_helper'

describe 'Administrador vê a lista de usuários cadastrados' do
  it 'se estiver autenticado' do
    company = create(:insurance_company)
    common_user = create(:user, insurance_company_id: company.id)

    login_as common_user, scope: :user
    visit root_path

    expect(page).not_to have_link 'Usuários'
  end

  context 'a partir de uma tela separada' do
    it 'com sucesso' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      create(
        :user, name: 'Petra', email: 'petra@paolaseguros.com.br',
               registration_number: '12345678911', status: :approved,
               insurance_company_id: company.id
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

    it 'e vê somente os usuários com cadastro pendente' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )
      create(
        :user, name: 'Ana', email: 'anaborba@petraseguros.com.br',
               registration_number: '12345678911', status: :approved,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit users_path
      select 'Usuários pendentes', from: 'filter_option'
      click_on 'Selecionar'

      expect(current_path).to eq users_path
      expect(page).to have_content 'Paola'
      expect(page).to have_content 'paola@petraseguros.com.br'
      expect(page).to have_content '39401920391'
      expect(page).to have_content 'Cadastro pendente'
      expect(page).to have_link 'Avaliar Cadastro'
      expect(page).not_to have_content 'Ana'
      expect(page).not_to have_content 'anaborba@petraseguros.com.br'
      expect(page).not_to have_content '12345678911'
      expect(page).not_to have_content 'Cadastro aprovado'
    end

    it 'e vê somente os usuários com cadastro aprovado' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )
      create(
        :user, name: 'Ana', email: 'anaborba@petraseguros.com.br',
               registration_number: '12345678911', status: :approved,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit users_path
      select 'Usuários aprovados', from: 'filter_option'
      click_on 'Selecionar'

      expect(current_path).to eq users_path
      expect(page).to have_content 'Ana'
      expect(page).to have_content 'anaborba@petraseguros.com.br'
      expect(page).to have_content '12345678911'
      expect(page).to have_content 'Cadastro aprovado'
      expect(page).not_to have_content 'Paola'
      expect(page).not_to have_content 'paola@petraseguros.com.br'
      expect(page).not_to have_content '39401920391'
      expect(page).not_to have_content 'Cadastro pendente'
      expect(page).not_to have_link 'Avaliar Cadastro'
    end

    it 'e vê somente os usuários com cadastro reprovado' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )
      create(
        :user, name: 'Ana', email: 'anaborba@petraseguros.com.br',
               registration_number: '12345678911', status: :approved,
               insurance_company_id: company.id
      )
      create(
        :user, name: 'Beatriz', email: 'bealindacheirosa@petraseguros.com.br',
               registration_number: '97081507411', status: :refused,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit users_path
      select 'Usuários reprovados', from: 'filter_option'
      click_on 'Selecionar'

      expect(current_path).to eq users_path
      expect(page).to have_content 'Beatriz'
      expect(page).to have_content 'bealindacheirosa@petraseguros.com.br'
      expect(page).to have_content '97081507411'
      expect(page).to have_content 'Cadastro recusado'
      expect(page).not_to have_content 'Ana'
      expect(page).not_to have_content 'anaborba@petraseguros.com.br'
      expect(page).not_to have_content '12345678911'
      expect(page).not_to have_content 'Cadastro aprovado'
      expect(page).not_to have_content 'Paola'
      expect(page).not_to have_content 'paola@petraseguros.com.br'
      expect(page).not_to have_content '39401920391'
      expect(page).not_to have_content 'Cadastro pendente'
      expect(page).not_to have_link 'Avaliar Cadastro'
    end
  end

  context 'e vê botão de alteração de cadastro' do
    it 'de um usuário pendente' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit users_path

      expect(page).to have_link 'Avaliar Cadastro'
    end

    it 'e não vê botão caso o usuário já esteja aprovado' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Petra APROVADA', email: 'petraaprovada@paolaseguros.com.br',
               registration_number: '39401920391', status: :approved,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit users_path

      expect(page).to have_content 'Petra APROVADA'
      expect(page).not_to have_link 'Avaliar Cadastro'
    end
  end

  context 'e muda o status do cadastro' do
    it 'a partir de um formulário' do
      company = create(:insurance_company)
      admin = create(:admin)
      create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit users_path
      click_on 'Avaliar Cadastro'

      expect(page).to have_content 'Aprovar Cadastro?'
      expect(page).to have_content 'Sim'
      expect(page).to have_content 'Não'
      expect(page).to have_field 'Motivo de reprovação'
      expect(page).to have_button 'Enviar'
    end

    it 'para aprovado' do
      company = create(:insurance_company)
      admin = create(:admin)
      common_user = create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit new_user_user_review_path(common_user.id)
      choose 'user_review_status_approved', allow_label_click: true
      click_on 'Enviar'

      expect(page).to have_content 'Usuário aprovado com sucesso.'
      expect(page).to have_content 'Paola'
      expect(page).to have_content 'paola@petraseguros.com.br'
      expect(page).to have_content 'Cadastro aprovado'
    end

    it 'para recusado' do
      company = create(:insurance_company)
      admin = create(:admin)
      common_user = create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit new_user_user_review_path(common_user.id)
      choose 'user_review_status_refused', allow_label_click: true
      fill_in 'Motivo de reprovação', with: 'Hacker invadindo o sistemaa!'
      click_on 'Enviar'

      expect(page).to have_content 'Usuário reprovado com sucesso.'
      expect(page).to have_content 'Paola'
      expect(page).to have_content 'paola@petraseguros.com.br'
      expect(page).to have_content 'Cadastro recusado'
    end

    it 'e não preenche a reprovação com uma justificativa' do
      company = create(:insurance_company)
      admin = create(:admin)
      common_user = create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit new_user_user_review_path(common_user.id)
      choose 'user_review_status_refused', allow_label_click: true
      fill_in 'Motivo de reprovação', with: ''
      click_on 'Enviar'

      expect(page).to have_content 'Motivo de reprovação deve ser preenchido para recusar o cadastro.'
    end

    it 'e não pode preencher um motivo de reprovação se for aprovar o cadastro' do
      company = create(:insurance_company)
      admin = create(:admin)
      common_user = create(
        :user, name: 'Paola', email: 'paola@petraseguros.com.br',
               registration_number: '39401920391', status: :pending,
               insurance_company_id: company.id
      )

      login_as admin, scope: :admin
      visit new_user_user_review_path(common_user.id)
      choose 'user_review_status_approved', allow_label_click: true
      fill_in 'Motivo de reprovação', with: 'Não gostei de você você é feio!!!'
      click_on 'Enviar'

      expect(page).to have_content 'Motivo de reprovação não pode ser preenchido para aprovar o cadastro.'
    end
  end
end
