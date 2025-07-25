require 'sidekiq'
require 'sentry-ruby'

class HeartbeatWorker
  include Sidekiq::Worker
  include Sentry::Cron::MonitorCheckIns

  sentry_monitor_check_ins(
    slug: 'ruby-sidekiq-cron',
    monitor_config: Sentry::Cron::MonitorConfig.from_crontab('* * * * *')
  )

  def perform
    puts "[#{Time.now}] Sending heartbeat ping..."
    
    # Simulate some work
    sleep(0.1)
    
    puts "[#{Time.now}] Heartbeat sent successfully!"
  end
end