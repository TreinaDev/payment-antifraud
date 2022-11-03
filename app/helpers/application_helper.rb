module ApplicationHelper

  def user_greetings(user)
    "Olá #{user.name} - #{user.email}"
  end
end