require 'rails_helper'

describe 'Administrador edita um meio de pagamento' do
  it 'e está autenticado como administrador' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:payment_method)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Laranja'

    expect(page).to have_link 'Editar'
  end

  it 'e não está autenticado como administrador' do
    user = FactoryBot.create(:user, :skip_email_validate)
    FactoryBot.create(:payment_method)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Laranja'

    expect(current_url).to eq payment_method_url(1)
    expect(page).not_to have_link 'Editar'
  end

  it 'a partir do menu' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:payment_method)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Laranja'
    click_on 'Editar'

    expect(current_url).to eq edit_payment_method_url(1)
    expect(page).to have_content 'Editar Meio de Pagamento'
    expect(page).to have_field 'Nome', with: 'Laranja'
    expect(page).to have_field 'Taxa por Cobrança', with: '5'
    expect(page).to have_field 'Taxa Máxima', with: '100'
    expect(page).to have_field 'Tipo de Pagamento'
    expect(page).to have_button 'Salvar'
  end

  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:payment_method)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Laranja'
    click_on 'Editar'
    fill_in 'Nome', with: 'Cartão Roxinho'
    fill_in 'Taxa por Cobrança', with: 5
    fill_in 'Taxa Máxima', with: 2
    select 'Boleto', from: 'Tipo de Pagamento'
    click_on 'Salvar'

    expect(current_url).to eq payment_method_url(1)
    expect(page).to have_content 'Meio de Pagamento atualizado com sucesso.'
    expect(page).to have_content 'Detalhes do Meio de Pagamento'
    expect(page).to have_content 'Nome: Cartão Roxinho'
    expect(page).to have_content 'Taxa por Cobrança: 5%'
    expect(page).to have_content 'Taxa Máxima: R$ 2,00'
    expect(page).to have_content 'Tipo de Pagamento: Boleto'
    expect(page).to have_content 'Status: Ativo'
  end

  it 'com informações faltando' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:payment_method)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Laranja'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Taxa por Cobrança', with: ''
    fill_in 'Taxa Máxima', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar o meio de pagamento.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Taxa por Cobrança não pode ficar em branco'
    expect(page).to have_content 'Taxa Máxima não pode ficar em branco'
  end
end
