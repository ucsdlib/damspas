# This file is used by Rack-based servers to start the application.

# Initialize Honeycomb logging for staging and production
if %w[staging production].include? Rails.env
  require 'honeycomb-beeline'
  Honeycomb.init(
    writekey: ENV.fetch('APPS_DHH_HONEYCOMB_KEY') { 'default' },
    dataset: ENV.fetch('APPS_DHH_HONEYCOMB_DATASET') { 'default' }
  )
end

require ::File.expand_path('../config/environment',  __FILE__)
run Hydra::Application

