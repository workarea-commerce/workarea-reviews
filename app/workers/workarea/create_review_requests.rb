module Workarea
  class CreateReviewRequests
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options(
      enqueue_on: {
        Order => :place,
        only_if: -> { Workarea.config.send_transactional_emails }
      },
      queue: 'low'
    )

    def perform(order_id)
      order = Order.find(order_id)
      product_ids = order.items
                         .sort_by(&:original_unit_price)
                         .reverse
                         .map(&:product_id)
                         .uniq
                         .take(Workarea.config.review_requests_per_order)

      product_ids.each do |product_id|
        Review::Request.create(
          email: order.email,
          order_id: order.id,
          user_id: order.user_id,
          product_id: product_id
        )
      end
    end
  end
end
