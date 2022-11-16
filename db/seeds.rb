Promo.destroy_all
CompanyPaymentOption.destroy_all
User.destroy_all
Admin.destroy_all
InsuranceCompany.destroy_all
PaymentMethod.destroy_all

company = FactoryBot.create(:insurance_company)
primary_user = FactoryBot.create(:user, email: 'users@antifraudsystem.com.br', password: 'password', name: 'Teste',
                                        status: 'approved', insurance_company_id: company.id)
5.times do
  FactoryBot.create(:user, status: 'pending', insurance_company_id: company.id)
end

FactoryBot.create(:admin, email: 'admins@antifraudsystem.com.br', password: 'password', name: 'Teste')

Promo.create!(name: 'Black Friday', starting_date: Time.zone.today, ending_date: Time.zone.today + 30.days,
              discount_max: 10_000, discount_percentage: 20, usages_max: 10, insurance_company_id: company.id)
Promo.create!(name: 'Promo de Natal', starting_date: Time.zone.today, ending_date: Time.zone.today + 15.days,
              discount_max: 15_000, discount_percentage: 15, usages_max: 50, insurance_company_id: company.id)
Promo.create!(name: 'Promo de Fim de Ano', starting_date: Time.zone.today,
              ending_date: Time.zone.today + 20.days, discount_max: 5000, discount_percentage: 10,
              usages_max: 100, insurance_company_id: company.id)
Promo.create!(name: 'Promo Relâmpago', starting_date: Time.zone.today, ending_date: Time.zone.today + 7.days,
              discount_max: 5000, discount_percentage: 10, usages_max: 150, insurance_company_id: company.id)

target_pay_method = FactoryBot.create(:payment_method, name: 'Laranja',
                                                       tax_percentage: 5, tax_maximum: 100,
                                                       payment_type: 'Cartão de Crédito', status: :active)
FactoryBot.create(:payment_method, name: 'Roxo',
                                   tax_percentage: 3, tax_maximum: 50,
                                   payment_type: 'Boleto', status: :active)

FactoryBot.create(
  :company_payment_option,
  user: primary_user,
  payment_method: target_pay_method,
  insurance_company: company,
  max_parcels: 12,
  single_parcel_discount: 1
)
