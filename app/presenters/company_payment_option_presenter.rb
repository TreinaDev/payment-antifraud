class CompanyPaymentOptionPresenter < SimpleDelegator 
  include ActionView::Helpers::TextHelper

  def with_payment_method_name
    "#{CompanyPaymentOption.model_name.human(count: 1)}: #{self.payment_method.name}"
  end

  def show_discount_if_present
    self.single_parcel_discount.zero? ? I18n.translate('messages.dont_have') : "#{self.single_parcel_discount}%"
  end
end