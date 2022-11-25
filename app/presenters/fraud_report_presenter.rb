class FraudReportPresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def formatted_registration_number
    "#{registration_number[0..2]}." \
      "#{registration_number[3..5]}." \
      "#{registration_number[6..8]}-" \
      "#{registration_number[9..10]}"
  end
end
