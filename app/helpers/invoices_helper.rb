module InvoicesHelper
  def format_registration_number(num)
    "#{num[0..2]}.#{num[3..5]}.#{num[6..8]}-#{num[9..10]}"
  end
end
