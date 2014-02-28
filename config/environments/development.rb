Hydra::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

    # action mailer 
  config.action_mailer.delivery_method = :sendmail
  # Defaults to:
  # config.action_mailer.sendmail_settings = {
  #   location: '/usr/sbin/sendmail',
  #   arguments: '-i -t'
  # }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: 'dlp@ucsd.edu'}

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # environment-specific DAMS config
  # ip-based role assignment
  config.public_ips = []
  config.local_ip_blocks = [ "192.168.0.", "192.168.1." ]
  config.wowza_directory = '/pub/data2/dams/'
  config.wowza_baseurl = 'lib-streaming.ucsd.edu:1935/dams4-test/_definst_/'
  config.role_vocab = "#{config.id_namespace}bb14141414"
  config.lang_vocab ="#{config.id_namespace}bb43434343"
  config.excluded_collections = "(bd5905379f OR bb13664503)"
  config.developer_groups = ['developer-authenticated','dams-curator','dams-manager-admin', 'dams-manager-user']
  config.curator_groups = ['dams-curator','dams-rci','dams-manager-admin']
  config.super_role = 'dams-manager-admin'
  config.unknown_groups = ['unknown']
  config.zoomify_baseurl = 'http://rohan.ucsd.edu/zoomify/'
  config.shibboleth = false
end
