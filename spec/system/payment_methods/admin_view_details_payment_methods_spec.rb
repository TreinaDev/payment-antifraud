require 'rails_helper'

describe 'Usuário vê detalhes de um meio de pagamento' do
  it 'se estiver autenticado' do
    FactoryBot.create(:payment_method)

    visit payment_method_url(1)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso negado.'
  end

  it 'a partir da tela inicial' do
    admin = FactoryBot.create(:admin)
    image = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/icone_cartao_credito_azul.jpg'))
    FactoryBot.create(:payment_method, name: 'Laranja',
                                       tax_percentage: 5, tax_maximum: 100,
                                       payment_type: 'Cartão de Crédito', status: :active,
                                       image:)
    FactoryBot.create(:payment_method, name: 'Roxo',
                                       tax_percentage: 3, tax_maximum: 50,
                                       payment_type: 'Boleto', status: :inactive,
                                       image:)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Meios de Pagamento'
    click_on 'Roxo'

    expect(page).to have_content 'Detalhes do Meio de Pagamento'
    expect(page).to have_content 'Roxo'
    expect(page).to have_content 'Taxa por Cobrança: 3%'
    expect(page).to have_content 'Taxa Máxima: R$ 50,00'
    expect(page).to have_content 'Tipo de Pagamento: Boleto'
    expect(page).to have_content 'Status: Inativo'
    expect(page).to have_css('img[src*="icone_cartao_credito_azul.jpg"]')
    expect(page).not_to have_content 'Nome: Laranja'
    expect(page).not_to have_content 'Taxa por Cobrança: 5%'
    expect(page).not_to have_content 'Taxa Máxima: R$ 100,00'
    expect(page).not_to have_content 'Tipo de Pagamento: Cartão de Crédito'
    expect(page).not_to have_content 'Status: Ativo'
  end
end
