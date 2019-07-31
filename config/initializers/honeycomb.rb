if ENV['APPS_DHH_HONEYCOMB_KEY'].present?
  Honeycomb.configure do |config|
    config.write_key = ENV.fetch('APPS_DHH_HONEYCOMB_KEY') { 'default' }
    config.dataset = ENV.fetch('APPS_DHH_HONEYCOMB_DATASET') { 'default' }
    config.notification_events = %w[
      sql.active_record
      render_template.action_view
      render_partial.action_view
      render_collection.action_view
      process_action.action_controller
      send_file.action_controller
      send_data.action_controller
      deliver.action_mailer
    ].freeze
  end
end
