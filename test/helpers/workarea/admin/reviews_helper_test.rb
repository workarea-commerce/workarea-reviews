require 'test_helper'

module Workarea
  module Admin
    class ReviewsHelperTest < ViewTest
      def test_reviewer_info_only_shows_link_when_user_is_present
        review = create_review(
          user_id: nil,
          product_id: create_product.id,
          user_info: 'Userless User'
        )

        assert_equal('Userless User', reviewer_info(review))
      end
    end
  end
end
