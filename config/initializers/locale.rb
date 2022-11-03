<<<<<<< HEAD
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
I18n.available_locales = [:'pt-BR']
I18n.default_locale = :'pt-BR'
=======
# Permitted locales available for the application
I18n.available_locales = [:en, :'pt-BR']

# Set default locale to something other than :en
I18n.default_locale = :'pt-BR'
>>>>>>> Configura o I18n no model promo
