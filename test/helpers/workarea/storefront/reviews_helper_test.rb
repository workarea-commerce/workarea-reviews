require 'test_helper'

module Workarea
  module Storefront
    class ReviewsHelperTest < ViewTest
      def test_rating_stars_displays_correct_rating
        assert_match(/1(?:\.0)? out of 5 stars/, rating_stars(1))
        assert_match(/2\.5 out of 5 stars/, rating_stars(2.5))
        assert_match(/4\.25 out of 5 stars/, rating_stars(4.251))
      end

      def test_rating_stars_outputs_correct_number_of_stars
        assert_equal(1, rating_stars(1).scan(/<title>star<\/title>/).size)
        assert_equal(4, rating_stars(4.251).scan(/<title>star<\/title>/).size)
        assert_equal(1, rating_stars(4.5).scan(/<title>half_star<\/title>/).size)
      end
    end
  end
end
