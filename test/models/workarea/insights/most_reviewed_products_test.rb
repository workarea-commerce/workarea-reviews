require 'test_helper'

module Workarea
  module Insights
    class MostReviewedProductsTest < TestCase
      setup :add_data, :time_travel

      def add_data
        travel_to Time.zone.local(2018, 10, 27)

        6.times { create_review(product_id: 'foo', approved: true) }
        12.times { create_review(product_id: 'bar', approved: true) }
      end

      def time_travel
        travel_to Time.zone.local(2018, 11, 1)
      end

      def test_generate_monthly!
        MostReviewedProducts.generate_monthly!
        assert_equal(1, MostReviewedProducts.count)

        reviewed_products = MostReviewedProducts.first
        assert_equal(2, reviewed_products.results.size)
        assert_equal('bar', reviewed_products.results.first['product_id'])
        assert_in_delta(12, reviewed_products.results.first['reviews'])
        assert_equal('foo', reviewed_products.results.second['product_id'])
        assert_in_delta(6, reviewed_products.results.second['reviews'])
      end
    end
  end
end
