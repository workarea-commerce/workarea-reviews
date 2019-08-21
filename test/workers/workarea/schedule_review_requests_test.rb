require 'test_helper'

module Workarea
  class ScheduleReviewRequestsTest < TestCase
    setup :order, :requests

    def order
      @order ||= create_order(
        items: [
          { product_id: 'PROD1', sku: 'SKU1', quantity: 1 },
          { product_id: 'PROD2', sku: 'SKU2', quantity: 1 },
          { product_id: 'PROD3', sku: 'SKU3', quantity: 1 }
        ]
      )
    end

    def requests
      @requests ||= [
        create_review_request(order_id: order.id, product_id: 'PROD1', send_after: nil),
        create_review_request(order_id: order.id, product_id: 'PROD2', send_after: nil),
        create_review_request(order_id: order.id, product_id: 'PROD3', send_after: nil)
      ]
    end

    def test_perform
      travel(3.days) do
        ScheduleReviewRequests.new.perform(
          order.id,
          [
            { 'id' => order.items.first.id.to_s },
            { 'id' => order.items.second.id.to_s },
            { 'id' => order.items.third.id.to_s }
          ]
        )

        requests.map(&:reload)
        assert(requests.all?(&:send_after))

        sorted_requests = requests.sort_by(&:send_after)

        assert_equal(
          Time.current + Workarea.config.review_request_initial_delivery_delay,
          sorted_requests.first.send_after
        )

        assert_equal(
          sorted_requests.first.send_after + Workarea.config.review_request_secondary_delivery_delay,
          sorted_requests.second.send_after
        )

        assert_equal(
          sorted_requests.second.send_after + Workarea.config.review_request_secondary_delivery_delay,
          sorted_requests.third.send_after
        )
      end
    end

    def test_perform_with_partial_shipments
      travel_to(3.days.from_now.beginning_of_day) do
        ScheduleReviewRequests.new.perform(
          order.id,
          [
            { 'id' => order.items.first.id.to_s },
            { 'id' => order.items.third.id.to_s }
          ]
        )

        requests.map(&:reload)
        assert_equal(2, requests.select(&:send_after).size)

        sorted_requests = requests.select(&:send_after).sort_by(&:send_after)

        assert_equal(
          Time.current + Workarea.config.review_request_initial_delivery_delay,
          sorted_requests.first.send_after
        )

        assert_equal(
          sorted_requests.first.send_after + Workarea.config.review_request_secondary_delivery_delay,
          sorted_requests.second.send_after
        )
      end

      travel_to(5.days.from_now.beginning_of_day) do
        ScheduleReviewRequests.new.perform(
          order.id,
          [
            { 'id' => order.items.first.id.to_s },
            { 'id' => order.items.second.id.to_s }
          ]
        )

        requests.map(&:reload)
        assert(requests.all?(&:send_after))

        sorted_requests = requests.sort_by(&:send_after)

        assert_equal(
          2.days.ago + Workarea.config.review_request_initial_delivery_delay,
          sorted_requests.first.send_after
        )

        assert_equal(
          sorted_requests.first.send_after + Workarea.config.review_request_secondary_delivery_delay,
          sorted_requests.second.send_after
        )

        assert_equal(
          sorted_requests.second.send_after + Workarea.config.review_request_secondary_delivery_delay,
          sorted_requests.third.send_after
        )
      end
    end
  end
end
