Hydra::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

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

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # i18n
  config.i18n.fallbacks = true

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
