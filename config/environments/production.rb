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
  # config.relative_url_root = ""

  #SMTP
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => 'pregase.chubut@gmail.com',
  :password             => 'elzzpregase99',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }

end
