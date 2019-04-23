# This file is used by Rack-based servers to start the application.

require 'honeycomb-beeline'
Honeycomb.init(
  writekey: ENV.fetch('APPS_DHH_HONEYCOMB_KEY') { 'default' },
  dataset: ENV.fetch('APPS_DHH_HONEYCOMB_DATASET') { 'default' }
)

require ::File.expand_path('../config/environment',  __FILE__)
run Hydra::Application

