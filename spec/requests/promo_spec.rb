require 'rails_helper'

describe 'Funcionário tenta acessar promoções' do
  it 'e não consegue acessar promoção cadastrada por outra seguradora' do
    company_a = FactoryBot.create(:insurance_company)
    company_b = FactoryBot.create(:insurance_company)
    create(:promo, insurance_company_id: company_a.id)
    promo_b = create(:promo, insurance_company_id: company_b.id)
    user = FactoryBot.create(:user, insurance_company_id: company_a.id)

    login_as user, scope: :user
    get promo_path(promo_b)

    expect(response).to redirect_to root_path
  end
end
