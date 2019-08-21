require 'test_helper'

module Workarea
  module Insights
    class TopRatedProductsTest < TestCase
      setup :add_data, :time_travel

      def add_data
        create_review(product_id: 'foo', rating: 3, created_at: Time.zone.local(2018, 10, 27))
        create_review(product_id: 'foo', rating: 3, created_at: Time.zone.local(2018, 10, 28))
        create_review(product_id: 'foo', rating: 3, created_at: Time.zone.local(2018, 10, 28))
        create_review(product_id: 'foo', rating: 5, created_at: Time.zone.local(2018, 10, 29))
        create_review(product_id: 'foo', rating: 3, created_at: Time.zone.local(2018, 10, 29))
        create_review(product_id: 'foo', rating: 2, created_at: Time.zone.local(2018, 10, 29))

        create_review(product_id: 'bar', rating: 3, created_at: Time.zone.local(2018, 10, 27))
        create_review(product_id: 'bar', rating: 4, created_at: Time.zone.local(2018, 10, 27))
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 27))
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 28))
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 28))
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 28))
        create_review(product_id: 'bar', rating: 4, created_at: Time.zone.local(2018, 10, 28))
        create_review(product_id: 'bar', rating: 4, created_at: Time.zone.local(2018, 10, 29))
        create_review(product_id: 'bar', rating: 4, created_at: Time.zone.local(2018, 10, 29))
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 29))
        create_review(product_id: 'bar', rating: 5, created_at: Time.zone.local(2018, 10, 29))
        create_review(product_id: 'bar', rating: 3, created_at: Time.zone.local(2018, 10, 29))
      end

      def time_travel
        travel_to Time.zone.local(2018, 11, 1)
      end

      def test_generate_monthly!
        TopRatedProducts.generate_monthly!
        assert_equal(1, TopRatedProducts.count)

        rated_products = TopRatedProducts.first
        assert_equal(2, rated_products.results.size)
        assert_equal('bar', rated_products.results.first['product_id'])
        assert_equal(4.33, rated_products.results.first['average_rating'].round(2))
        assert_equal(3.73, rated_products.results.first['weighted_average_rating'].round(2))
        assert_equal('foo', rated_products.results.second['product_id'])
        assert_equal(3.17, rated_products.results.second['average_rating'].round(2))
        assert_equal(3.06, rated_products.results.second['weighted_average_rating'].round(2))
      end
    end
  end
end
