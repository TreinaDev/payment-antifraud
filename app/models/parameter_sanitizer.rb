class ParameterSanitizer < Devise::ParameterSanitizer 
  def initialize(*)
    super 
    permit(:sign_up, keys: [:name, :registration_number])
  end
end