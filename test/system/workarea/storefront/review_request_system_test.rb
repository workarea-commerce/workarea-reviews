require 'test_helper'

module Workarea
  module Storefront
    class ReviewRequestSystemTest < Workarea::SystemTest
      def test_completing_a_review_request
        order = create_placed_order
        product = create_product
        user = create_user(first_name: 'Bob', last_name: 'Clams')

        review_request = create_review_request(
          product_id: product.id,
          order_id: order.id,
          email: order.email,
          user_id: user.id
        )

        visit storefront.review_request_path(review_request.token)

        assert(page.has_content?(product.name))

        within '#review_request_form' do
          execute_script("$('#review_rating_4').trigger('click')")
          fill_in 'review[title]', with: 'Pretty decent product'
          fill_in 'review[body]', with: 'It works well.'
          click_button 'submit_review'
        end

        assert_current_path(storefront.product_path(product))
        assert(page.has_content?('Success'))
      end
    end
  end
end
