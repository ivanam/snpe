ProyectoBase::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Algo de rails4
  config.eager_load = true

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify


  # Aca va el scope
  config.relative_url_root = "/soft/snpe"

  config.assets.prefix = "/soft/snpe/assets"

  config.action_mailer.perform_deliveries = true 
  config.action_mailer.raise_delivery_errors = true

  #mail de respaldo cuando supera el maximo de enviados:
  #mecinscripciones2018@gmail.com
  #mecinscripciones2019@gmail.com


  #SMTP
  config.action_mailer.default_url_options = { :host => 'www.chubut.edu.ar/' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  :address              => "smtp.googlemail.com",
  :port                 => 465,
  :domain               => 'gmail.com',
  :user_name            => 'mecinscripciones20194@gmail.com',
  :password             => '_12345678',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }

end
