source 'https://rubygems.org'

gem 'rails', '~> 4.2.4'
gem 'blacklight', '~> 4.7.0' # locked
gem 'hydra-head', '~> 6.5.2' # locked
gem 'active-fedora', '~> 6.7.8' # locked
gem 'solrizer', '~> 3.1.0' # locked
gem 'blacklight_advanced_search', '~> 2.2.0' # locked
gem 'kaminari', '~> 0.15.1' # locked (0.16.0+ breaks pagination)

# private fork of solrizer-fedora with auto-commit disabled
#gem 'solrizer-fedora', '3.0.0.pre1' # PRE-LOCK
gem "solrizer-fedora", github: 'ucsdlib/solrizer-fedora', ref: '87c2d35e'

gem 'sitemap_generator', '~> 5.1.0'

gem 'sqlite3', '~> 1.3.10'

gem 'devise', '~> 3.5.2'
gem 'omniauth', '~> 1.2.2' # 1.2.2 breaks test sign_in
gem 'omniauth-shibboleth', '~> 1.2.0'
gem 'equivalent-xml', '~> 0.6.0'

gem 'jquery-rails', '~> 4.0.5'
gem 'rails_autolink', '~> 1.1.6'
gem 'mail_form', '~> 1.5.0'
gem 'qa', '~> 0.5.0'
gem 'sprockets', '~> 3.3.4'
gem 'rack-dev-mark', '~> 0.7.3'

# Deploy with Capistrano
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano-rbenv', '~> 2.0.2'
gem 'capistrano-bundler', '~> 1.1.3'

gem "unicode", '0.4.4', :platforms => [:mri_18, :mri_19]
gem "i18n", '~> 0.7.0'
gem "bootstrap-sass", '~> 2.3.2.2' # locked because blacklight 4.7
gem "bower-rails", "~> 0.10.0"
gem "responders", "~> 2.1.0"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.1', :platforms => :ruby
gem 'uglifier', '~> 2.7.2'

group :development, :test do
  gem 'sass-rails', '~> 5.0.4'
  gem 'coffee-rails', '~> 4.1.0'
  gem 'pry', '~> 0.10.1'
  gem 'capybara', '~> 2.5.0'
  gem 'launchy', '~> 2.4.3'
  gem "minitest", '~> 5.8.0'
  gem 'rspec-rails', '~> 2.14.2' # locked (2.99+ breaks rspec_junit_formatter)
  gem 'simplecov', '~> 0.10.0'
  gem 'unicorn', '~> 4.9.0'
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem "codeclimate-test-reporter", '~> 0.4.8', require: nil
end

group :staging do
  gem 'activerecord-postgresql-adapter'
  gem 'rake', '~> 10.4.0'
end
