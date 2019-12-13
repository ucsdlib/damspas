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

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Prepend all log lines with the following tags
  config.log_tags = [ :subdomain, :uuid ]

  # Expend to set up logger with STDOUT
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # environment-specific DAMS config
  # ip-based role assignment
  config.public_ips = []
  config.local_ip_blocks = [ "10.192.", "10.193.", "10.194.", "10.195.", "10.196.", "10.197.", "10.198.", "10.199.", "10.200.", "10.201.", "10.202.", "10.203.", "10.204.", "10.205.", "10.206.", "10.207.", "67.58.32.", "67.58.33.", "67.58.34.", "67.58.35.", "67.58.36.", "67.58.37.", "67.58.38.", "67.58.39.", "67.58.40.", "67.58.41.", "67.58.42.", "67.58.43.", "67.58.44.", "67.58.45.", "67.58.46.", "67.58.47.", "67.58.48.", "67.58.49.", "67.58.50.", "67.58.51.", "67.58.52.", "67.58.53.", "67.58.54.", "67.58.55.", "67.58.56.", "67.58.57.", "67.58.58.", "67.58.59.", "67.58.60.", "67.58.61.", "67.58.62.", "67.58.63.", "69.169.32.", "69.169.33.", "69.169.34.", "69.169.35.", "69.169.36.", "69.169.37.", "69.169.38.", "69.169.39.", "69.169.40.", "69.169.41.", "69.169.42.", "69.169.43.", "69.169.44.", "69.169.45.", "69.169.46.", "69.169.47.", "69.169.48.", "69.169.49.", "69.169.50.", "69.169.51.", "69.169.52.", "69.169.53.", "69.169.54.", "69.169.55.", "69.169.56.", "69.169.57.", "69.169.58.", "69.169.59.", "69.169.60.", "69.169.61.", "69.169.62.", "69.169.63.", "128.54.", "132.239.", "132.249.", "137.110.", "169.228.", "172.16.", "172.17.", "172.18.", "172.19.", "172.20.", "172.21.", "172.22.", "172.23.", "192.31.21.", "192.35.224.", "192.67.21.", "192.135.237.", "192.135.238.", "192.168.237.", "192.168.238.", "198.202.64.", "198.202.72.", "198.202.73.", "198.202.74.", "198.202.75.", "198.202.76.", "198.202.77.", "198.202.78.", "192.202.79.", "198.202.80.", "198.202.81.", "198.202.82.", "198.202.83.", "198.202.84.", "198.202.85.", "198.202.86.", "198.202.87.", "198.202.88.", "198.202.89.", "198.202.90.", "198.202.91.", "198.202.92.", "198.202.93.", "198.202.94.", "198.202.95.", "198.202.96.", "198.202.97.", "198.202.98.", "198.202.99.", "198.202.100.", "198.202.101.", "198.202.102.", "198.202.103.", "198.202.104.", "198.202.105.", "198.202.106.", "198.202.107.", "198.202.108.", "198.202.109.", "198.202.110.", "198.202.111.", "198.202.112.", "198.202.113.", "198.202.114.", "198.202.115.", "198.202.116.", "198.202.117.", "198.202.118.", "198.202.119.", "198.202.120.", "198.202.121.", "198.202.122.", "198.202.123.", "198.202.124.", "198.202.125.", "198.202.126.", "198.202.127.", "233.28.209." ]
  config.wowza_directory = '/pub/data2/dams/'
  config.wowza_baseurl = 'lib-streaming.ucsd.edu/dams4-test/_definst_/'
  config.role_vocab = "#{config.id_namespace}bb14141414"
  config.lang_vocab ="#{config.id_namespace}bb43434343"
  config.excluded_collections = "(bd5905379f OR bb13664503)"
  config.developer_groups = ['developer-authenticated','dams-curator','dams-manager-admin', 'dams-manager-user', 'dams-vrr']
  config.curator_groups = ['dams-curator','dams-editor','dams-manager-admin']
  config.editor_groups = ['dams-editor','dams-manager-admin']
  config.super_role = 'dams-manager-admin'
  config.vrr_role = ['dams-vrr']
  config.unknown_groups = ['unknown']
  config.zoomify_baseurl = 'https://rohan.ucsd.edu/zoomify/'
  config.shibboleth = true
  config.share_notify_sample = 'share_notify.yml.staging.sample'
end
