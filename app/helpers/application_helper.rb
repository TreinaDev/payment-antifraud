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

  def bootstrap_link(controller)
    "nav-link px-2 link-#{controller_name == controller ? 'primary' : 'gray'}"
  end
end
