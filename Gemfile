source 'https://rubygems.org'

gem 'rails', '~> 4.1.8'
gem 'blacklight', '~> 4.7.0' # 5.7.2
gem 'hydra-head', '~> 6.5.2' # 7.2.2
gem 'active-fedora', '~> 6.7.8' # 7.1.2
gem 'solrizer', '~> 3.1.0' # 3.3.0
gem 'blacklight_advanced_search', '~> 2.2.0' # 5.1.1
gem 'kaminari', '~> 0.15.0' # 0.16.0 breaks pagination

# private fork of solrizer-fedora with auto-commit disabled
#gem 'solrizer-fedora', '3.0.0.pre1' # PRE-LOCK
gem "solrizer-fedora", github: 'ucsdlib/solrizer-fedora', ref: '87c2d35e'

gem 'sitemap_generator', '~> 5.0.5'
gem 'ezid-client', '~> 0.11.0'

gem 'sqlite3', '~> 1.3.10'

gem 'devise', '~> 3.4.1'
gem 'omniauth', '~> 1.2.2' # 1.2.2 breaks test sign_in
gem 'omniauth-shibboleth', '~> 1.2.0'
gem 'equivalent-xml', '~> 0.5.1'

gem 'jquery-rails', '~> 3.1.2'
gem 'rails_autolink', '~> 1.1.6'
gem 'mail_form', '~> 1.5.0'
gem 'qa', '~> 0.3.0'
gem 'sprockets', '~> 2.12.3'
gem 'rack-dev-mark', '~> 0.7.3'

# Deploy with Capistrano
gem 'capistrano', '~> 3.3.3'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano-rbenv', '~> 2.0.2'
gem 'capistrano-bundler', '~> 1.1.3'

gem "unicode", '0.4.4', :platforms => [:mri_18, :mri_19]
gem "i18n", '~> 0.6.9'
gem "bootstrap-sass", '~> 2.3.0'
gem "bower-rails", "~> 0.9.2"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.1', :platforms => :ruby
gem 'uglifier', '~> 2.5.3'

group :development, :test do
  gem 'sass-rails', '~> 4.0.5'
  gem 'coffee-rails', '~> 4.1.0'
  gem 'pry', '~> 0.10.1'
  gem 'capybara', '~> 2.4.4'
  gem 'launchy', '~> 2.4.3'
  gem "minitest", '~> 5.4.3'
  gem 'rspec-rails', '~> 2.14.2' # 2.99+ breaks rspec_junit_formatter
  gem 'simplecov', '~> 0.9.1'
  gem 'unicorn', '~> 4.8.3'
  gem 'rspec_junit_formatter', '~> 0.2.0'
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 10.4.0'
end
