source 'https://rubygems.org'

gem 'rails', '~> 4.2.10'
gem 'blacklight', '~> 4.7.0' # locked
gem 'hydra-head', '~> 6.5.2' # locked
gem 'active-fedora', '~> 6.7.8' # locked
gem 'solrizer', '~> 3.1.0' # locked
gem 'blacklight_advanced_search', '~> 2.2.0' # locked
gem 'kaminari', '~> 0.15.1' # locked (0.16.0+ breaks pagination)
gem 'share_notify', git: 'https://github.com/samvera-labs/share_notify', branch: 'master'

# private fork of solrizer-fedora with auto-commit disabled
#gem 'solrizer-fedora', '3.0.0.pre1' # PRE-LOCK
gem "solrizer-fedora", git: 'https://github.com/ucsdlib/solrizer-fedora', ref: '87c2d35e'

gem 'sitemap_generator', '~> 5.3.1'

gem 'pg', '~> 0.18.2'
gem 'activerecord-postgresql-adapter'

gem 'devise', '~> 3.5.5'
gem 'omniauth', '~> 1.7.1' # 1.2.2 breaks test sign_in
gem 'omniauth-shibboleth', '~> 1.2.1'
gem 'equivalent-xml', '~> 0.6.0'

gem 'jquery-rails', '~> 4.3.1'
gem 'rails_autolink', '~> 1.1.6'
gem 'qa', '~> 1.1.0'
gem 'sprockets', '~> 2.12.4'  # locked
gem 'rack-dev-mark', '~> 0.7.5'

# Deploy with Capistrano
gem 'capistrano', '~> 3.8.1'
gem 'capistrano-rails', '~> 1.2.3'
gem 'capistrano-rbenv', '~> 2.1.1'
gem 'capistrano-bundler', '~> 1.2.0'

gem "i18n", '~> 0.8.1'
gem "bootstrap-sass", '~> 2.3.2.2' # locked because blacklight 4.7
gem "bower-rails", "~> 0.11.0"
gem "responders", "~> 2.4.0"
gem 'nokogiri', '1.8.4'

gem 'uglifier', '~> 3.2.0'
gem 'rspec-mocks', '3.6.0'
gem 'newrelic_rpm', '5.3.0.346'

gem 'lograge', '0.5.1'
gem 'logstash-event', '1.2.02'
gem 'coveralls', '0.8.21', require: false
gem 'rubyzip', '1.2.2'

group :development, :test do
  gem 'byebug'
  gem 'sass-rails', '~> 5.0.5' # locked
  gem 'coffee-rails', '~> 4.2.1'
  gem 'pry', '~> 0.10.4'
  gem 'capybara', '~> 2.14.0'
  gem 'selenium-webdriver', '3.4.0'
  gem 'launchy', '~> 2.4.3'
  gem "minitest", '~> 5.10.2'
  gem 'rspec-rails', '3.6.0'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'simplecov', '~> 0.14.1'
  gem 'rubocop', '0.58.2', require: false
  gem 'rubocop-rspec', '1.15.1'
  gem 'unicorn', '~> 5.3.0'
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem 'poltergeist', '1.15.0'
end

group :staging do
  gem 'rake', '~> 12.3.1'
end
