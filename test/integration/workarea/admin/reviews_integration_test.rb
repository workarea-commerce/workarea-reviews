require 'test_helper'

module Workarea
  module Admin
    class ReviewsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_updating_a_review
        review = create_review(product_id: product.id)

        put admin.review_path(review), params: {
          review: { body: 'foo bar', approved: true }
        }

        review.reload
        assert_equal('foo bar', review.body)
        assert(review.approved)
      end

      def test_deleting_a_review
        review = create_review(product_id: product.id)
        delete admin.review_path(review)
        assert_empty(Review)
      end

      private

      def product
        @product ||= create_product
      end
    end
  end
end
