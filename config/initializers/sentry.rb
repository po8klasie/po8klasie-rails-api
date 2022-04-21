Sentry.init do |config|
    # config.dsn is deliberately not configured.
    # The dsn will be collected fron SENTRY_DSN env variable
    
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    
    if Rails.env.production?
        config.traces_sample_rate = 1
    else 
        config.traces_sample_rate = 0
    end
    # or
    config.traces_sampler = lambda do |context|
        true
    end
end