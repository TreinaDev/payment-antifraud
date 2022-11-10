require 'rails_helper'

describe 'Usuário registra novo meio de pagamento para sua seguradora' do
  it 'a partir de um formulário' do
    user = FactoryBot.create(:user, status: :approved)

    login_as user, scope: :user
    visit root_path
    click_on 'Configurar Meios de Pagamento'
    click_on 'Novo Meio de Pagamento'

    expect(page).to have_content 'Configurar Meio de Pagamento'
    expect(page).to have_field 'Meio de Pagamento'
    expect(page).to have_field 'Quantidade Máxima de Parcelas'
    expect(page).to have_field 'Desconto à vista'
    expect(page).to have_button 'Enviar'
  end 

  it 'com sucesso' do 
    user = FactoryBot.create(:user, status: :approved)
    FactoryBot.create(:payment_method, name: 'Cartão Nubank')

    login_as user, scope: :user
    visit new_company_payment_option_path

    select 'Cartão Nubank', from: 'Meio de Pagamento'
    fill_in 'Quantidade Máxima de Parcelas', with: '6'
    fill_in 'Desconto à vista', with: '5'
    click_on 'Enviar'
    
    expect(current_path).to eq company_payment_options_path
    expect(page).to have_content 'Meio de pagamento'
    expect(page).to have_content 'Cartão Nubank'
    expect(page).to have_content 'Qtd. Máx. de Parcelas'
    expect(page).to have_content '6'
    expect(page).to have_content 'Desconto à vista'
    expect(page).to have_content '5'
  end
end