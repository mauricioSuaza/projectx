Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redistogo:1bf44e595246953e504fb3c5be07c9c1@angelfish.redistogo.com:9811/
' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redistogo:1bf44e595246953e504fb3c5be07c9c1@angelfish.redistogo.com:9811/'
 }
end