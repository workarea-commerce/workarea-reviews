require 'test_helper'

module Workarea
  class ReviewRequestParamsTest < TestCase
    def product
      @product ||= create_product
    end

    def order
      @order ||=
        create_placed_order.tap { |o| o.update_attributes(user_id: user.id) }
    end

    def user
      @user ||= create_user(first_name: 'Robert', last_name: 'Clams')
    end

    def test_to_h
      params = { rating: 3, body: 'foo bar' }
      request = create_review_request(
        product_id: product.id,
        order_id: order.id,
        email: order.email,
        user_id: user.id
      )

      assert_equal(
        {
          rating: 3,
          body: 'foo bar',
          product_id: product.id.to_s,
          user_id: user.id.to_s,
          email: order.email,
          user_info: 'RC',
          first_name: 'Robert',
          last_name: 'Clams',
          verified: true
        },
        ReviewRequestParams.new(request, params).to_h
      )

      request = create_review_request(
        product_id: product.id,
        order_id: order.id,
        email: order.email,
      )

      assert_equal(
        {
          rating: 3,
          body: 'foo bar',
          product_id: product.id.to_s,
          user_id: nil,
          email: order.email,
          user_info: 'BC',
          first_name: 'Ben',
          last_name: 'Crouse',
          verified: true
        },
        ReviewRequestParams.new(request, params).to_h
      )
    end
  end
end
