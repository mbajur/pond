# Rails defaults the test env's ActiveJob adapter to :test, which only
# records enqueued jobs and never runs them - unlike development/production,
# which use :async/:solid_queue and actually execute jobs. Turbo's
# broadcast_*_later_to helpers defer the ActionCable broadcast into
# Turbo::Streams::ActionBroadcastJob, so under :test that broadcast would
# simply never fire and JS specs driving a real browser would never see it.
#
# Scoped to just this job class (rather than flipping the adapter globally)
# because other jobs in the app do real external work - e.g.
# UrlThumbnailer::FetchMetaJob makes a live HTTP request - that we don't want
# firing synchronously inside a request/response cycle in specs.
Turbo::Streams::ActionBroadcastJob.queue_adapter = :inline
