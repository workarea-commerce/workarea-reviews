require 'test_helper'

module Workarea
  module Reports
    class ReviewsByUserTest < TestCase
      setup :add_data, :time_travel

      def add_data
        create_review(email: 'foo@workarea.com', user_id: nil, rating: 4, created_at: Time.zone.local(2018, 10, 27), approved: true, verified: true)
        create_review(email: 'foo@workarea.com', user_id: '123', rating: 3, created_at: Time.zone.local(2018, 10, 28), approved: true, verified: true)
        create_review(email: 'foo@workarea.com', user_id: '123', rating: 4, created_at: Time.zone.local(2018, 10, 28), approved: true)
        create_review(email: 'foo@workarea.com', user_id: nil, rating: 4, created_at: Time.zone.local(2018, 10, 29), approved: true)
        create_review(email: 'foo@workarea.com', user_id: nil, rating: 3, created_at: Time.zone.local(2018, 10, 29), approved: false)
        create_review(email: 'foo@workarea.com', user_id: nil, rating: 2, created_at: Time.zone.local(2018, 10, 29), approved: false)

        create_review(email: 'bar@workarea.com', user_id: nil, rating: 3, created_at: Time.zone.local(2018, 10, 27), approved: true, verified: true)
        create_review(email: 'bar@workarea.com', user_id: '456', rating: 4, created_at: Time.zone.local(2018, 10, 28), approved: true)
        create_review(email: 'bar@workarea.com', user_id: nil, rating: 5, created_at: Time.zone.local(2018, 10, 28), approved: false)
        create_review(email: 'bar@workarea.com', user_id: nil, rating: 5, created_at: Time.zone.local(2018, 10, 29), approved: false)
        create_review(email: 'bar@workarea.com', user_id: nil, rating: 3, created_at: Time.zone.local(2018, 10, 29), approved: false)
      end

      def time_travel
        travel_to Time.zone.local(2018, 10, 30)
      end

      def test_grouping_and_summing
        report = ReviewsByUser.new
        assert_equal(2, report.results.length)

        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(6, foo['reviews'])
        assert_equal(2, foo['verified'])
        assert_equal(3.33, foo['average_rating'].round(2))
        assert_equal('123', foo['user_id'])
        assert_equal(7.5, foo['activity_score'])

        bar = report.results.detect { |r| r['_id'] == 'bar@workarea.com' }
        assert_equal(5, bar['reviews'])
        assert_equal(1, bar['verified'])
        assert_equal(4, bar['average_rating'])
        assert_equal('456', bar['user_id'])
        assert_equal(5.75, bar['activity_score'])
      end

      def test_date_ranges
        report = ReviewsByUser.new
        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(6, foo['reviews'])

        report = ReviewsByUser.new(starts_at: '2018-10-28', ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(2, foo['reviews'])

        report = ReviewsByUser.new(starts_at: '2018-10-28', ends_at: '2018-10-29')
        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(5, foo['reviews'])

        report = ReviewsByUser.new(starts_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(5, foo['reviews'])

        report = ReviewsByUser.new(ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(3, foo['reviews'])
      end

      def test_sorting
        report = ReviewsByUser.new(sort_by: 'average_rating', sort_direction: 'asc')
        assert_equal('foo@workarea.com', report.results.first['_id'])

        report = ReviewsByUser.new(sort_by: 'average_rating', sort_direction: 'desc')
        assert_equal('bar@workarea.com', report.results.first['_id'])

        report = ReviewsByUser.new(sort_by: 'reviews', sort_direction: 'desc')
        assert_equal('foo@workarea.com', report.results.first['_id'])
      end

      def test_filtering
        report = ReviewsByUser.new(results_filter: 'unapproved')

        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(2, foo['reviews'])
        assert_equal(2.5, foo['average_rating'].round(2))

        bar = report.results.detect { |r| r['_id'] == 'bar@workarea.com' }
        assert_equal(3, bar['reviews'])
        assert_equal(4.33, bar['average_rating'].round(2))

        report = ReviewsByUser.new(results_filter: 'approved')

        foo = report.results.detect { |r| r['_id'] == 'foo@workarea.com' }
        assert_equal(4, foo['reviews'])
        assert_equal(3.75, foo['average_rating'].round(2))

        bar = report.results.detect { |r| r['_id'] == 'bar@workarea.com' }
        assert_equal(2, bar['reviews'])
        assert_equal(3.5, bar['average_rating'])
      end
    end
  end
end
