unless Workarea.config.skip_service_connections
  Sidekiq::Cron::Job.create(
    name: 'Workarea::SendReviewRequests',
    klass: 'Workarea::SendReviewRequests',
    cron: "0 0 * * * #{Time.zone.tzinfo.identifier}",
    queue: 'low'
  )
end
