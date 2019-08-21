require 'test_helper'

module Workarea
  module Insights
    class MostActiveReviewersTest < TestCase
      setup :add_data, :time_travel

      def add_data
        travel_to Time.zone.local(2018, 10, 27)

        5.times { create_review(email: 'foo@workarea.com', approved: true, verified: true) }
        7.times { create_review(email: 'bar@workarea.com', approved: true) }
      end

      def time_travel
        travel_to Time.zone.local(2018, 11, 1)
      end

      def test_generate_monthly!
        MostActiveReviewers.generate_monthly!
        assert_equal(1, MostActiveReviewers.count)

        reviewers = MostActiveReviewers.first
        assert_equal(2, reviewers.results.size)
        assert_equal('foo@workarea.com', reviewers.results.first['email'])
        assert_in_delta(5, reviewers.results.first['reviews'])
        assert_equal('bar@workarea.com', reviewers.results.second['email'])
        assert_in_delta(7, reviewers.results.second['reviews'])
      end
    end
  end
end
