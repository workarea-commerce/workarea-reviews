module Workarea
  class ScheduleReviewRequests
    include Sidekiq::Worker

    sidekiq_options queue: 'low'

    def perform(order_id, shipped_items)
      requests = Review::Request.by_order(order_id).to_a
      return if requests.all?(&:send_after)

      order = Order.find(order_id)
      product_ids =
        shipped_items.map do |item|
          order_item = order.items.detect { |i| i.id.to_s == item['id'] }
          order_item&.product_id
        end
        .compact

      schedule_requests(
        requests.select { |request| request.product_id.in?(product_ids) },
        requests
      )
    end

    def schedule_requests(affected_requests, all_requests)
      affected_requests.each do |request|
        next if request.send_after.present?

        last_scheduled =
          all_requests.select(&:send_after).sort_by(&:send_after).last

        date_to_send =
          if last_scheduled.present?
            last_scheduled.send_after +
              Workarea.config.review_request_secondary_delivery_delay
          else
            Workarea.config.review_request_initial_delivery_delay.from_now
          end

        request.update_attributes(send_after: date_to_send)
      end
    end
  end
end
