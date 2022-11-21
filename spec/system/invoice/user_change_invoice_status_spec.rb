require 'rails_helper'

describe 'Usuário altera status de uma cobrança' do
  it 'a partir da tela de detalhes' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                     registration_number: '12345678', status: :pending, voucher: 'Black123')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Cobranças'
    click_on 'Ver mais'

    expect(page).to have_link 'Sucesso no Pagamento'
    expect(page).to have_link 'Falha no Pagamento'
  end

  it 'e vai para formulário de informações adicionais' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Sucesso no Pagamento'

    expect(page).to have_content 'Atualizar pagamento da cobrança'
    expect(page).to have_field 'Número de registro da transação'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso para Sucesso no Pagamento' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Sucesso no Pagamento'
    fill_in 'Número de registro da transação', with: '12345678901'
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança atualizada com sucesso'
    expect(page).to have_content 'Status: Sucesso no Pagamento'
    expect(page).to have_content 'Número de registro da transação: 12345678901'
    expect(page).not_to have_link 'Sucesso no Pagamento'
    expect(page).not_to have_link 'Falha no Pagamento'
  end

  it 'com sucesso para Falha no Pagamento' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Falha no Pagamento'
    fill_in 'Motivo da falha', with: 'Transação negada pela bandeira'
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança atualizada com sucesso'
    expect(page).to have_content 'Status: Falha no Pagamento'
    expect(page).to have_content 'Motivo da falha: Transação negada pela bandeira'
    expect(page).not_to have_link 'Sucesso no Pagamento'
    expect(page).not_to have_link 'Falha no Pagamento'
  end

  it 'para Falha no Pagamento com informações incompletas' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Falha no Pagamento'
    fill_in 'Motivo da falha', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança não foi atualizada'
    expect(page).to have_content 'Motivo da falha não pode ficar em branco'
    expect(page).not_to have_content 'Número de registro da transação não pode ficar em branco'
  end

  it 'para Sucesso no Pagamento com informações incompletas' do
    company = FactoryBot.create(:insurance_company)
    user = FactoryBot.create(:user, insurance_company_id: company.id)
    payment_method = create(:payment_method)
    FactoryBot.create(:company_payment_option, insurance_company_id: company.id,
                                               payment_method_id: payment_method.id, user:)
    invoice = create(:invoice, payment_method:, insurance_company_id: company.id, package_id: 10,
                               registration_number: '12345678', status: :pending, voucher: 'Black123')

    login_as(user, scope: :user)
    visit invoice_url(invoice.id)
    click_on 'Sucesso no Pagamento'
    fill_in 'Número de registro da transação', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Cobrança não foi atualizada'
    expect(page).not_to have_content 'Motivo da falha não pode ficar em branco'
    expect(page).to have_content 'Número de registro da transação não pode ficar em branco'
  end
end
