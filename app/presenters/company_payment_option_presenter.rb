class CompanyPaymentOptionPresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def user_name_and_email
    "#{user.name} | #{user.email}"
  end

  def with_payment_method_name
    "#{CompanyPaymentOption.model_name.human(count: 1)}: #{payment_method.name}"
  end

  def show_discount_if_present
    single_parcel_discount.zero? ? I18n.t('messages.dont_have') : "#{single_parcel_discount}%"
  end
end
