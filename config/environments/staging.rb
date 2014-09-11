Hydra::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += ['ckeditor/ckeditor.js','home-page.js','home-page.css']

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

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

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
  config.zoomify_baseurl = 'http://librarytest.ucsd.edu/zoomify/'
  config.shibboleth = true
end
