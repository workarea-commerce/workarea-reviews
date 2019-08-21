require 'test_helper'

module Workarea
  module Storefront
    class ReviewRequestsIntegrationTest < Workarea::IntegrationTest
      def test_show
        order = create_placed_order

        review_request = create_review_request(
          product_id: create_product.id,
          order_id: order.id,
          email: order.email
        )

        get storefront.review_request_path(review_request.token)
        assert(response.ok?)

        review_request.complete!

        get storefront.review_request_path(review_request.token)
        assert_redirected_to(storefront.root_path)
        assert(flash[:error].present?)
      end

      def test_complete
        order = create_placed_order
        product = create_product

        review_request = create_review_request(
          product_id: product.id,
          order_id: order.id,
          email: order.email
        )

        other_requests = Array.new(2) do
          create_review_request(
            product_id: '123',
            order_id: order.id,
            email: order.email
          )
        end

        post storefront.complete_review_request_path(review_request.token),
             params: {
               review: {
                 rating: 4,
                 body: 'Exactly what I was looking for.'
               }
             }

        assert_redirected_to(storefront.product_path(product))
        assert(flash[:success].present?)

        review_request.reload
        assert(review_request.completed?)
        assert_equal(1, Review.count)

        other_requests.each(&:reload)
        assert(other_requests.all?(&:canceled?))
      end
    end
  end
end
