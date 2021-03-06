require 'sidekiq'
require 'sidekiq-status'

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:#{ENV['REDIS_PORT'] || '6390'}", namespace: "healthypath_#{Rails.env}", size: 2 }
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  # The config.redis is calculated by the
  # concurrency value so you do not need to
  # specify this. For this demo I do
  # show it to understand the numbers
  config.redis = { url: "redis://localhost:#{ENV['REDIS_PORT'] || '6390'}", namespace: "healthypath_#{Rails.env}", size: 9 }
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end