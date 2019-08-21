require 'test_helper'

module Workarea
  class Review
    class RequestTest < TestCase
      def test_cancel_for_orders!
        requests = Array.new(3) { create_review_request }

        request = requests.first
        Review::Request.cancel_for_orders!(request.order_id)
        assert(request.reload.canceled?)

        Review::Request.cancel_for_orders!(requests.map(&:order_id))
        assert(requests.each(&:reload).all?(&:canceled?))
      end
    end
  end
end
