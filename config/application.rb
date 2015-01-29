require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler) 
  Bundler.require(:default, :assets, Rails.env)
end
Bundler.require(:default, Rails.env)

#Bundler.require(*Rails.groups)

module ProyectoBase
  class Application < Rails::Application

    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.assets.compile = true
    config.assets.enabled = true
  end
end
