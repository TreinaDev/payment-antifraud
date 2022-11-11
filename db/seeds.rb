User.destroy_all
Admin.destroy_all
Promo.destroy_all
PaymentMethod.destroy_all

company = FactoryBot.create(:insurance_company)
FactoryBot.create(:user, email: 'users@antifraudsystem.com.br', password: 'password', name: 'Teste', status: 'approved', insurance_company_id: company.id)
5.times do
  FactoryBot.create(:user, status: 'pending', insurance_company_id: company.id)
end

FactoryBot.create(:admin, email: 'admins@antifraudsystem.com.br', password: 'password', name: 'Teste')

Promo.create!(name: 'Black Friday', starting_date: Time.zone.today, ending_date: Time.zone.today + 30.days,
              discount_max: 10_000, discount_percentage: 20, product_list: 'notebooks, smartphones', usages_max: 10)
Promo.create!(name: 'Promo de Natal', starting_date: Time.zone.today, ending_date: Time.zone.today + 15.days,
              discount_max: 15_000, discount_percentage: 15, product_list: 'smartphones', usages_max: 50)
Promo.create!(name: 'Promo de Fim de Ano', starting_date: Time.zone.today,
              ending_date: Time.zone.today + 20.days, discount_max: 5000, discount_percentage: 10,
              product_list: 'notebooks', usages_max: 100)
Promo.create!(name: 'Promo Relâmpago', starting_date: Time.zone.today, ending_date: Time.zone.today + 7.days,
              discount_max: 5000, discount_percentage: 10, product_list: 'notebooks', usages_max: 150)

FactoryBot.create(:payment_method, name: 'Laranja',
                                   tax_percentage: 5, tax_maximum: 100,
                                   payment_type: 'Cartão de Crédito', status: :active)
FactoryBot.create(:payment_method, name: 'Roxo',
                                   tax_percentage: 3, tax_maximum: 50,
                                   payment_type: 'Boleto', status: :active)
