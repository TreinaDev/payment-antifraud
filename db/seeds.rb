Promo.destroy_all
CompanyPaymentOption.destroy_all
InsuranceCompany.destroy_all
Invoice.destroy_all
PaymentMethod.destroy_all
User.destroy_all
Admin.destroy_all

company = FactoryBot.create(:insurance_company)
primary_user = FactoryBot.create(:user, email: 'users@antifraudsystem.com.br', password: 'password', name: 'Teste',
                                        status: 'approved', insurance_company_id: company.id)
5.times do
  FactoryBot.create(:user, status: :pending, insurance_company_id: company.id)
end
5.times do
  FactoryBot.create(:user, status: :approved, insurance_company_id: company.id)
end
5.times do
  FactoryBot.create(:user, status: :refused, insurance_company_id: company.id)
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

payment_method1 = FactoryBot.create(:payment_method, name: 'Laranja',
                                                     tax_percentage: 5, tax_maximum: 100, max_parcels: 12,
                                                     payment_type: 'Cartão de Crédito', status: :active)
payment_method2 = FactoryBot.create(:payment_method, name: 'Roxo',
                                                     tax_percentage: 3, tax_maximum: 50, max_parcels: 1,
                                                     payment_type: 'Boleto', status: :active)
payment_method3 = FactoryBot.create(:payment_method, name: 'Amarelo',
                                                     tax_percentage: 0, tax_maximum: 20, max_parcels: 1,
                                                     payment_type: 'Pix', status: :active)

FactoryBot.create(
  :company_payment_option,
  user: primary_user,
  payment_method: payment_method1,
  insurance_company: company,
  max_parcels: 12,
  single_parcel_discount: 1
)
FactoryBot.create(
  :company_payment_option,
  user: primary_user,
  payment_method: payment_method2,
  insurance_company: company,
  max_parcels: 1,
  single_parcel_discount: 1
)
FactoryBot.create(
  :company_payment_option,
  user: primary_user,
  payment_method: payment_method3,
  insurance_company: company,
  max_parcels: 1,
  single_parcel_discount: 1
)

5.times do |i|
  i += 1
  FactoryBot.create(:invoice, status: 'pending', insurance_company_id: company.id,
                              package_id: i, registration_number: '12345678987',
                              payment_method_id: payment_method1.id, order_id: i)
end

FactoryBot.create(
  :fraud_report,
  insurance_company_id: company.id,
  description: "Ela é daquelas mulheres que projetam fachadas para o mundo.
                               Ela é vigarista, trapaceira, e se aproveita das pessoas mais indefesas que poderia haver
                               tudo para conseguir o que ela quer"
)
