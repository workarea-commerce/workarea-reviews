require 'test_helper'

module Workarea
  module Storefront
    class ReviewViewModelTest < TestCase
      def test_requires_public_info?
        review = Review.new
        assert(ReviewViewModel.wrap(review).requires_public_info?)

        user = create_user(first_name: nil, last_name: nil)
        review.user_id = user.id
        assert(ReviewViewModel.wrap(review).requires_public_info?)

        user.update!(first_name: 'Bob', last_name: 'Clams')
        refute(ReviewViewModel.wrap(review).requires_public_info?)

        user.destroy!
        assert(ReviewViewModel.wrap(review).requires_public_info?)
      end

      def test_anonymous?
        review = Review.new
        assert(ReviewViewModel.wrap(review).anonymous?)

        user = create_user
        review.user_id = user.id
        refute(ReviewViewModel.wrap(review).anonymous?)

        user.destroy!
        assert(ReviewViewModel.wrap(review).anonymous?)
      end

      def test_user
        review = Review.new
        assert_nil(ReviewViewModel.wrap(review).user)

        user = create_user
        review.user_id = user.id
        assert_equal(user, ReviewViewModel.wrap(review).user)

        user.destroy!
        assert_nil(ReviewViewModel.wrap(review).user)
      end
    end
  end
end
