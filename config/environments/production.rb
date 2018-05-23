Hydra::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  config.log_tags = [ :subdomain, :uuid ]

  # set up logger with STDOUT
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += ['home-page.js','home-page.css']

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # environment-specific DAMS config
  # ip-based role assignment
  config.public_ips = []
  config.local_ip_blocks = [ "10.192.", "10.193.", "10.194.", "10.195.", "10.196.", "10.197.", "10.198.", "10.199.", "10.200.", "10.201.", "10.202.", "10.203.", "10.204.", "10.205.", "10.206.", "10.207.", "67.58.32.", "67.58.33.", "67.58.34.", "67.58.35.", "67.58.36.", "67.58.37.", "67.58.38.", "67.58.39.", "67.58.40.", "67.58.41.", "67.58.42.", "67.58.43.", "67.58.44.", "67.58.45.", "67.58.46.", "67.58.47.", "67.58.48.", "67.58.49.", "67.58.50.", "67.58.51.", "67.58.52.", "67.58.53.", "67.58.54.", "67.58.55.", "67.58.56.", "67.58.57.", "67.58.58.", "67.58.59.", "67.58.60.", "67.58.61.", "67.58.62.", "67.58.63.", "69.169.32.", "69.169.33.", "69.169.34.", "69.169.35.", "69.169.36.", "69.169.37.", "69.169.38.", "69.169.39.", "69.169.40.", "69.169.41.", "69.169.42.", "69.169.43.", "69.169.44.", "69.169.45.", "69.169.46.", "69.169.47.", "69.169.48.", "69.169.49.", "69.169.50.", "69.169.51.", "69.169.52.", "69.169.53.", "69.169.54.", "69.169.55.", "69.169.56.", "69.169.57.", "69.169.58.", "69.169.59.", "69.169.60.", "69.169.61.", "69.169.62.", "69.169.63.", "128.54.", "132.239.", "132.249.", "137.110.", "169.228.", "172.16.", "172.17.", "172.18.", "172.19.", "172.20.", "172.21.", "172.22.", "172.23.", "192.31.21.", "192.35.224.", "192.67.21.", "192.135.237.", "192.135.238.", "192.168.237.", "192.168.238.", "198.202.64.", "198.202.72.", "198.202.73.", "198.202.74.", "198.202.75.", "198.202.76.", "198.202.77.", "198.202.78.", "192.202.79.", "198.202.80.", "198.202.81.", "198.202.82.", "198.202.83.", "198.202.84.", "198.202.85.", "198.202.86.", "198.202.87.", "198.202.88.", "198.202.89.", "198.202.90.", "198.202.91.", "198.202.92.", "198.202.93.", "198.202.94.", "198.202.95.", "198.202.96.", "198.202.97.", "198.202.98.", "198.202.99.", "198.202.100.", "198.202.101.", "198.202.102.", "198.202.103.", "198.202.104.", "198.202.105.", "198.202.106.", "198.202.107.", "198.202.108.", "198.202.109.", "198.202.110.", "198.202.111.", "198.202.112.", "198.202.113.", "198.202.114.", "198.202.115.", "198.202.116.", "198.202.117.", "198.202.118.", "198.202.119.", "198.202.120.", "198.202.121.", "198.202.122.", "198.202.123.", "198.202.124.", "198.202.125.", "198.202.126.", "198.202.127.", "233.28.209." ]
  config.wowza_directory = '/pub/data2/dams/'
  config.wowza_baseurl = 'lib-streaming.ucsd.edu:1936/dams4/_definst_/'
  config.role_vocab = "#{config.id_namespace}bb14141414"
  config.lang_vocab ="#{config.id_namespace}bb43434343"
  config.excluded_collections = "(bd5905379f OR bb13664503)"
  config.developer_groups = ['public']
  config.curator_groups = ['dams-curator','dams-editor','dams-manager-admin']
  config.editor_groups = ['dams-editor','dams-manager-admin']
  config.super_role = 'dams-manager-admin'
  config.unknown_groups = ['unknown']
  config.zoomify_baseurl = 'https://library.ucsd.edu/zoomify/'
  config.shibboleth = true
  config.host_name = 'https://library.ucsd.edu/dc'
  config.secure_token_audio_baseurl = 'lib-streaming.ucsd.edu:1936/dams4-securetoken/_definst_/mp3:'
  config.secure_token_video_baseurl = 'lib-streaming.ucsd.edu:1936/dams4-securetoken/_definst_/mp4:'
  config.secure_token_name = ENV.fetch('APPS_DHH_SECURE_TOKEN_NAME') {'default'}
  config.secure_token_secret = ENV.fetch('APPS_DHH_SECURE_TOKEN_SECRET') {'default'}
end
