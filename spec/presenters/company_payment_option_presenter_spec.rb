require 'rails_helper'

describe CompanyPaymentOptionPresenter do 
  context '#with_payment_method_name' do 
    it 'gera uma string com o nome do meio de pagamento' do 
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      payment_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank') 
      payment_option = FactoryBot.build(
                        :company_payment_option,
                        insurance_company: company,
                        payment_method: ,
                        user: )

      result = payment_option.decorate.with_payment_method_name 

      expect(result).to eq 'Meio de pagamento definido para seguradora: Cartão Nubank'
    end
  end

  context '#show_discount_if_present' do 
    it 'mostra desconto à vista quando existente' do 
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      payment_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank') 
      payment_option = FactoryBot.build(
                        :company_payment_option,
                        insurance_company: company,
                        payment_method: ,
                        user: ,
                        single_parcel_discount: 10)

      result = payment_option.decorate.show_discount_if_present

      expect(result).to eq '10%'
    end

    it 'e não há desconto' do 
      company = FactoryBot.create(:insurance_company)
      user = FactoryBot.create(:user, insurance_company_id: company.id)
      payment_method = FactoryBot.create(:payment_method, name: 'Cartão Nubank') 
      payment_option = FactoryBot.build(
                        :company_payment_option,
                        insurance_company: company,
                        payment_method: ,
                        user: ,
                        single_parcel_discount: 0)

      result = payment_option.decorate.show_discount_if_present

      expect(result).to eq 'Não Possui'
    end
  end
end