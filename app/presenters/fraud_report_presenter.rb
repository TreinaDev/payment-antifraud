class FraudReportPresenter < SimpleDelegator 
  include ActionView::Helpers::TextHelper

  def formatted_registration_number
    self.registration_number[0..2].to_s + '.' + 
    self.registration_number[3..5].to_s + '.' +
    self.registration_number[6..8].to_s + '-' +
    self.registration_number[9..10]
  end
end