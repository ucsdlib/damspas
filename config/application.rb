require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end


module Hydra
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/models/datastreams)
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true    
    # Default SASS Configuration, check out https://github.com/rails/sass-rails for details
    config.assets.compress = !Rails.env.development?



    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    config.id_namespace = 'http://library.ucsd.edu/ark:/20775/'
    config.role_vocab = "#{config.id_namespace}bb14141414"
    config.lang_vocab ="#{config.id_namespace}bb43434343"

    # ip-based role assignment
    config.public_ips = ["128.54.48.2","128.54.48.3","128.54.48.4","128.54.48.5","128.54.48.6","128.54.48.7","128.54.48.8","128.54.48.9","128.54.48.10","128.54.48.11","128.54.48.12","128.54.48.13","128.54.48.14"]
    config.local_ip_blocks  = ["67.58.32.","67.58.33.","67.58.34.","67.58.35.","67.58.36.","67.58.37.","67.58.38.","67.58.39.","67.58.40.","67.58.41.","67.58.42.","67.58.43.","67.58.44.","67.58.45.","67.58.46.","67.58.47.","67.58.48.","67.58.49.","67.58.50.","67.58.51.","67.58.52.","67.58.53.","67.58.54.","67.58.55.","67.58.56.","67.58.57.","67.58.58.","67.58.59.","67.58.60.","67.58.61.","67.58.62.","67.58.63.","128.54.","132.239.","132.249.","137.110.","169.228.","172.16.","172.17.","172.18.","172.19.","172.20.","192.135.237.","192.135.238.","192.31.21.","198.202.74.","198.202.75.","198.202.112.","198.202.113.","198.202.114.","198.202.115.","233.28.209."]
  end
end
