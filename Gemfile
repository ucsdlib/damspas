source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'blacklight' #, '4.2.0'
gem 'blacklight_advanced_search' #, '2.0.0'
gem 'solrizer-fedora', '3.0.0.pre1' # PRE-LOCK
gem 'solrizer' #, '3.0.0'
gem 'hydra-head' #, "6.0.0"
gem 'active-fedora', "6.4.5"
#gem "active-fedora", github: 'projecthydra/active_fedora', ref: '8a4777d' # > 6.4.4
#gem 'protected_attributes'

gem 'sqlite3' #, '1.3.7'

gem 'devise' #, '2.2.3'
gem 'omniauth' #, '1.1.4'
gem 'omniauth-shibboleth' #, '1.0.8'
gem 'equivalent-xml' #, '0.3.0'

gem 'jquery-rails'
gem 'rails_autolink'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
gem 'capistrano', '~> 3.0.0'

# To use debugger
# gem 'debugger'

gem "unicode", '0.4.4', :platforms => [:mri_18, :mri_19]
gem "bootstrap-sass" #, '2.2.2.0'

group :development, :test do
  gem 'sass-rails' #,   '3.2.6'
  gem 'coffee-rails' #, '3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.11.4', :platforms => :ruby

  gem 'uglifier' #, '2.0.1'
  gem 'capybara' #, '2.1.0'
  gem 'database_cleaner' #, '0.9.1'
  gem 'jettywrapper' #, '1.4.1'
  gem 'launchy' #, '2.3.0'
  gem 'rspec-rails' #, '2.13.0'
  gem 'simplecov' #, '0.7.1'
  gem 'unicorn' #, '4.6.2'
end

group :staging do
  gem 'activerecord-postgresql-adapter'
end
