Sentry.init do |config|
    # config.dsn is deliberately not configured.
    # The dsn will be collected fron SENTRY_DSN env variable
    
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # To activate performance monitoring, set one of these options.
    # We recommend adjusting the value in production:
    config.traces_sample_rate = 1
    # or
    config.traces_sampler = lambda do |context|
        true
    end
end