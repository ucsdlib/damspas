source 'https://rubygems.org'

gem 'rails', '~> 4.2.7.1'
gem 'blacklight', '~> 4.7.0' # locked
gem 'hydra-head', '~> 6.5.2' # locked
gem 'active-fedora', '~> 6.7.8' # locked
gem 'solrizer', '~> 3.1.0' # locked
gem 'blacklight_advanced_search', '~> 2.2.0' # locked
gem 'kaminari', '~> 0.15.1' # locked (0.16.0+ breaks pagination)
gem 'share_notify', '~> 0.2.0'

# private fork of solrizer-fedora with auto-commit disabled
#gem 'solrizer-fedora', '3.0.0.pre1' # PRE-LOCK
gem "solrizer-fedora", github: 'ucsdlib/solrizer-fedora', ref: '87c2d35e'

gem 'sitemap_generator', '~> 5.1.0'

gem 'sqlite3', '~> 1.3.11'

gem 'devise', '~> 3.5.5'
gem 'omniauth', '~> 1.3.1' # 1.2.2 breaks test sign_in
gem 'omniauth-shibboleth', '~> 1.2.1'
gem 'equivalent-xml', '~> 0.6.0'

gem 'jquery-rails', '~> 4.1.1'
gem 'rails_autolink', '~> 1.1.6'
gem 'mail_form', '~> 1.5.0'
gem 'qa', '~> 0.7.0'
gem 'sprockets', '~> 2.12.4'  # locked
gem 'rack-dev-mark', '~> 0.7.5'

# Deploy with Capistrano
gem 'capistrano', '~> 3.5.0'
gem 'capistrano-rails', '~> 1.1.7'
gem 'capistrano-rbenv', '~> 2.0.4'
gem 'capistrano-bundler', '~> 1.1.3'

gem "unicode", '0.4.4.3', :platforms => [:mri_18, :mri_19]
gem "i18n", '~> 0.7.0'
gem "bootstrap-sass", '~> 2.3.2.2' # locked because blacklight 4.7
gem "bower-rails", "~> 0.10.0"
gem "responders", "~> 2.2.0"
gem 'nokogiri', '1.6.8'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.1', :platforms => :ruby
gem 'uglifier', '~> 3.0.0'
gem 'rspec-mocks', '3.5.0'
gem 'newrelic_rpm', '3.16.0.318'

gem 'lograge', '0.4.1'
gem 'logstash-event', '1.2.02'

group :development, :test do
  gem 'sass-rails', '~> 5.0.5'
  gem 'coffee-rails', '~> 4.2.1'
  gem 'pry', '~> 0.10.3'
  gem 'capybara', '~> 2.6.0'
  gem 'selenium-webdriver', '2.53.4'
  gem 'launchy', '~> 2.4.3'
  gem "minitest", '~> 5.9.0'
  gem 'rspec-rails', '3.5.0' 
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'simplecov', '~> 0.11.2'
  gem 'unicorn', '~> 5.1.0'
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem "codeclimate-test-reporter", '~> 0.6.0', require: nil
  gem 'poltergeist', '1.10.0'
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 11.2.2'
end
