# Load environment variables
begin
  require 'dotenv'
  Dotenv.load(File.join(File.dirname(__FILE__), '..', '.env'))
rescue LoadError
  # dotenv gem not available, continue without it
end

# Load Sentry
require 'sentry-ruby'
require 'sentry-sidekiq'

# Check for required environment variables
if ENV['SENTRY_DSN'].nil? || ENV['SENTRY_DSN'].empty?
  puts "ERROR: SENTRY_DSN environment variable is not set"
  puts "Please set SENTRY_DSN in your environment or .env file"
  exit 1
end

if ENV['SENTRY_ENVIRONMENT'].nil? || ENV['SENTRY_ENVIRONMENT'].empty?
  puts "ERROR: SENTRY_ENVIRONMENT environment variable is not set"
  puts "Please set SENTRY_ENVIRONMENT in your environment or .env file"
  exit 1
end

# Initialize Sentry
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = ENV['SENTRY_ENVIRONMENT']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
  
  # Enable automatic Sidekiq-Cron monitoring
  config.enabled_patches += [:sidekiq_cron]
end

# Configure Sidekiq
require 'sidekiq'
require 'sidekiq-cron'

# Redis configuration
redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  
  # Load cron jobs on startup
  config.on(:startup) do
    schedule_file = File.join(File.dirname(__FILE__), 'schedule.yml')
    if File.exist?(schedule_file)
      schedule = YAML.load_file(schedule_file)
      Sidekiq::Cron::Job.load_from_hash!(schedule, source: "schedule")
      puts "Loaded #{schedule.size} cron jobs from schedule.yml"
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

# Load workers
require_relative '../app/workers/heartbeat_worker'