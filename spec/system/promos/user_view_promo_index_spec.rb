require 'rails_helper'
require 'support/api_shared_context_methods'

describe 'Funcionário visita a pagina de promoção' do
  include_context 'api_shared_context_methods'

  it 'e vê promoções cadastradas' do
    user_registration_api_mock

    promo_a = create(:promo)
    promo_b = create(:promo)

    visit promos_path

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content "Promoção: #{promo_a.name}"
    expect(page).to have_content "Promoção: #{promo_b.name}"
  end

  it 'e não há promoções cadastradas' do
    user_registration_api_mock

    visit promos_path

    expect(current_path).to eq promos_path
    expect(page).to have_content 'Promoções'
    expect(page).to have_content 'Cadastrar promoção'
    expect(page).to have_content 'Nenhuma promoção cadastrada.'
  end
end
