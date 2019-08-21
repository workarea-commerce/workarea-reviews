Workarea.configure do |config|
  config.seeds.insert('Workarea::InsightsSeeds', 'Workarea::ReviewSeeds')

  config.jump_to_navigation.merge!('Product Reviews' => :reviews_path)

  config.product_copy_default_attributes ||= {}
  config.product_copy_default_attributes.merge!(
    total_reviews: 0,
    average_rating: nil
  )

  config.data_file_ignored_fields << %w(total_reviews average_rating)

  config.insights_model_classes << 'Workarea::User'

  # The amount of time before a Review::Request will auto expire
  # and be removed from the collection
  config.review_request_ttl = 6.months

  # The maximum number of review requests to send for each order
  # Each request will be for a different order item, selected by
  # most expensive.
  config.review_requests_per_order = 3

  # The amount of time after an order is shipped before the first review
  # requests will be sent.
  config.review_request_initial_delivery_delay = 14.days

  # The amount of time after the last request was sent to send another.
  config.review_request_secondary_delivery_delay = 5.days
end
