require 'test_helper'

module Workarea
  module Reports
    class ReviewsByProductTest < TestCase
      setup :add_data, :time_travel

      def add_data
        create_review(product_id: 'foo', rating: 4, created_at: Time.zone.local(2018, 10, 27), approved: true, verified: true)
        create_review(product_id: 'foo', rating: 3, created_at: Time.zone.local(2018, 10, 28), approved: true, verified: true)
        create_review(product_id: 'foo', rating: 4, created_at: Time.zone.local(2018, 10, 28), approved: true)
        create_review(product_id: 'foo', rating: 4, created_at: Time.zone.local(2018, 10, 29), approved: true)
        create_review(product_id: 'foo', rating: 3, created_at: Time.zone.local(2018, 10, 29), approved: false)
        create_review(product_id: 'foo', rating: 2, created_at: Time.zone.local(2018, 10, 29), approved: false)

        create_review(product_id: 'bar', rating: 3, created_at: Time.zone.local(2018, 10, 27), approved: true, verified: true)
        create_review(product_id: 'bar', rating: 4, created_at: Time.zone.local(2018, 10, 28), approved: true)
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 28), approved: false)
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 29), approved: false)
        create_review(product_id: 'bar', rating: 3, created_at: Time.zone.local(2018, 10, 29), approved: false)
      end

      def time_travel
        travel_to Time.zone.local(2018, 10, 30)
      end

      def test_grouping_and_summing
        report = ReviewsByProduct.new
        assert_equal(2, report.results.length)

        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(6, foo['reviews'])
        assert_equal(2, foo['verified'])
        assert_equal(3.33, foo['average_rating'].round(2))
        assert_equal(3.13, foo['weighted_average_rating'].round(2))

        bar = report.results.detect { |r| r['_id'] == 'bar' }
        assert_equal(5, bar['reviews'])
        assert_equal(1, bar['verified'])
        assert_equal(4, bar['average_rating'])
        assert_equal(3.33, bar['weighted_average_rating'].round(2))
      end

      def test_date_ranges
        report = ReviewsByProduct.new
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(6, foo['reviews'])

        report = ReviewsByProduct.new(starts_at: '2018-10-28', ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(2, foo['reviews'])

        report = ReviewsByProduct.new(starts_at: '2018-10-28', ends_at: '2018-10-29')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(5, foo['reviews'])

        report = ReviewsByProduct.new(starts_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(5, foo['reviews'])

        report = ReviewsByProduct.new(ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(3, foo['reviews'])
      end

      def test_sorting
        report = ReviewsByProduct.new(sort_by: 'average_rating', sort_direction: 'asc')
        assert_equal('foo', report.results.first['_id'])

        report = ReviewsByProduct.new(sort_by: 'average_rating', sort_direction: 'desc')
        assert_equal('bar', report.results.first['_id'])

        report = ReviewsByProduct.new(sort_by: 'reviews', sort_direction: 'desc')
        assert_equal('foo', report.results.first['_id'])
      end

      def test_filtering
        report = ReviewsByProduct.new(results_filter: 'unapproved')

        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(2, foo['reviews'])
        assert_equal(2.5, foo['average_rating'].round(2))
        assert_equal(2.92, foo['weighted_average_rating'].round(2))

        bar = report.results.detect { |r| r['_id'] == 'bar' }
        assert_equal(3, bar['reviews'])
        assert_equal(4.33, bar['average_rating'].round(2))
        assert_equal(3.31, bar['weighted_average_rating'].round(2))

        report = ReviewsByProduct.new(results_filter: 'approved')

        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(4, foo['reviews'])
        assert_equal(3.75, foo['average_rating'].round(2))
        assert_equal(3.21, foo['weighted_average_rating'].round(2))

        bar = report.results.detect { |r| r['_id'] == 'bar' }
        assert_equal(2, bar['reviews'])
        assert_equal(3.5, bar['average_rating'])
        assert_equal(3.08, bar['weighted_average_rating'].round(2))
      end
    end
  end
end
