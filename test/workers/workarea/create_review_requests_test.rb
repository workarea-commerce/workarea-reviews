require 'test_helper'

module Workarea
  class CreateReviewRequestsTest < TestCase
    def test_perform
      product_one = create_product(variants: [{ sku: 'SKU1', regular: 5.to_m }])
      product_two = create_product(variants: [{ sku: 'SKU2', regular: 10.to_m }])
      product_three = create_product(variants: [{ sku: 'SKU3', regular: 15.to_m }])
      product_four = create_product(variants: [{ sku: 'SKU4', regular: 20.to_m }, { sku: 'SKU5', regular: 25.to_m }])

      user = create_user(first_name: 'Robert', last_name: 'Clams')
      order = create_order(
        user_id: user.id,
        email: user.email,
        items: [
          { product_id: product_one.id, sku: 'SKU1', quantity: 20 },
          { product_id: product_two.id, sku: 'SKU2', quantity: 2 },
          { product_id: product_three.id, sku: 'SKU3', quantity: 1 },
          { product_id: product_four.id, sku: 'SKU4', quantity: 1 },
          { product_id: product_four.id, sku: 'SKU5', quantity: 1 }
        ]
      )

      Sidekiq::Callbacks.disable(CreateReviewRequests) do
        complete_checkout(order)
      end

      assert_equal(0, Review::Request.count)
      CreateReviewRequests.new.perform(order.id)
      assert_equal(3, Review::Request.count)

      requests = Review::Request.all
      assert_includes(requests.map(&:product_id), product_four.id.to_s)
      assert_includes(requests.map(&:product_id), product_three.id.to_s)
      assert_includes(requests.map(&:product_id), product_two.id.to_s)
    end
  end
end
