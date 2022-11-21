module ApplicationHelper
  def user_greetings(user)
    "Olá #{user.name} - #{user.email}"
  end

  def show_discount_if_present(discount)
    discount.zero? ? t('messages.dont_have') : "#{discount}%"
  end

  def payment_option_with_name(name)
    "#{CompanyPaymentOption.model_name.human(count: 1)}: #{name}"
  end

  def formatted_registration_number(regis_num)
    "#{regis_num[0..2]}.#{regis_num[3..5]}.#{regis_num[6..8]}-#{regis_num[9..10]}"
  end
end
