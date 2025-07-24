#!/usr/bin/env ruby

require 'clockwork'
require 'time'
require 'sentry-ruby'

# Load .env file if it exists (but don't require it)
begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  # dotenv gem not available, continue without it
end

# Check if SENTRY_DSN is configured
if ENV['SENTRY_DSN'].nil? || ENV['SENTRY_DSN'].empty? || ENV['SENTRY_DSN'].include?('your-dsn-here')
  puts "ERROR: SENTRY_DSN is not configured!"
  puts "Please set the SENTRY_DSN environment variable"
  exit 1
end

# Check if SENTRY_ENVIRONMENT is configured
if ENV['SENTRY_ENVIRONMENT'].nil? || ENV['SENTRY_ENVIRONMENT'].empty?
  puts "ERROR: SENTRY_ENVIRONMENT is not configured!"
  puts "Please set the SENTRY_ENVIRONMENT environment variable (e.g., development, staging, production)"
  exit 1
end

# Initialize Sentry
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = ENV['SENTRY_ENVIRONMENT']
  config.breadcrumbs_logger = [:sentry_logger]
  config.traces_sample_rate = 1.0
end

module Clockwork
  handler do |job|
    puts "[#{Time.now}] Running #{job}"
  end

  # Heartbeat task that runs every minute
  every(1.minute, 'heartbeat') do
    # Create monitor config for every minute
    monitor_config = Sentry::Cron::MonitorConfig.from_crontab(
      '* * * * *',
      checkin_margin: 1,  # 1 minute check-in margin
      max_runtime: 2,     # 2 minutes max runtime
      timezone: 'UTC'
    )
    
    # Start check-in
    check_in_id = Sentry.capture_check_in(
      'ruby-clockwork-upsert',
      :in_progress,
      monitor_config: monitor_config
    )
    
    begin
      # Simulate work
      puts "[#{Time.now}] Sending heartbeat ping..."
      sleep(0.5)
      puts "[#{Time.now}] Heartbeat sent successfully!"
      
      # Mark check-in as successful
      Sentry.capture_check_in(
        'ruby-clockwork-upsert',
        :ok,
        check_in_id: check_in_id,
        monitor_config: monitor_config
      )
    rescue => e
      # Mark check-in as failed if an error occurs
      Sentry.capture_check_in(
        'ruby-clockwork-heartbeat',
        :error,
        check_in_id: check_in_id,
        monitor_config: monitor_config
      )
      Sentry.capture_exception(e)
      raise
    end
  end
end