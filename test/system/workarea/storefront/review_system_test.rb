require 'test_helper'

module Workarea
  module Storefront
    class ReviewSystemTest < Workarea::SystemTest
      def product
        @product ||= create_product(name: 'Test')
      end

      def test_showing_reviews_on_browse_page
        create_review(product_id: product.id, rating: 4)
        category = create_category(product_ids: [product.id])

        visit storefront.category_path(category)
        assert_includes(page.html, '4.0 out of 5 stars')
      end

      def test_showing_reviews_on_search_results
        create_product(name: 'Another Test')
        create_review(product_id: product.id, rating: 4)

        visit storefront.search_path(q: 'test')
        assert_includes(page.html, '4.0 out of 5 stars')
      end

      def test_showing_reviews_on_a_product_detail_page
        create_review(product_id: product.id, rating: 3)
        create_review(
          product_id: product.id,
          rating: 3,
          title: 'Integration Review First'
        )
        create_review(
          product_id: product.id,
          rating: 3,
          title: 'Integration Review Second'
        )

        visit storefront.product_path(product)

        assert_includes(page.html, '3.0')
        assert(page.has_content?('(3)'))
        assert(
          page.has_ordered_text?(
            'Integration Review Second',
            'Integration Review First'
          )
        )
      end

      def test_showing_review_from_verified_purchaser
        create_review(
          product_id: product.id,
          rating: 3,
          title: 'Integration Review',
          verified: true
        )

        visit storefront.product_path(product)
        assert(page.has_content?('Integration Review'))
        assert(page.has_content?(t('workarea.storefront.reviews.verified_purchaser')))
      end

      def test_writing_a_product_review
        create_user(
          email: 'test@workarea.com',
          password: 'w3bl1nc',
          name: 'Ben Crouse'
        )

        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: 'test@workarea.com'
          fill_in 'password', with: 'w3bl1nc'
          click_button 'login'
        end

        visit storefront.product_path(product)
        click_link 'Write a Review'

        within '#review_form' do
          # svg blocks input
          execute_script("$('#review_rating_4').trigger('click')")
          fill_in 'review[title]', with: 'Pretty decent product'
          fill_in 'review[body]', with: 'It works well.'
          click_button 'submit_review'
        end

        assert(page.has_content?('Success'))
        assert_no_selector('#review_form')
      end

      def test_writing_a_product_review_as_a_guest
        visit storefront.product_path(product)
        click_link 'Write a Review'

        within '#review_form' do
          # svg blocks input
          execute_script("$('#review_rating_4').trigger('click')")
          fill_in 'review[title]', with: 'Pretty decent product'
          fill_in 'review[body]', with: 'It works well.'
          fill_in 'review[first_name]', with: 'Ben'
          fill_in 'review[last_name]', with: 'Crouse'
          click_button 'submit_review'
        end

        assert(page.has_content?('Success'))
        assert_no_selector('#review_form')
      end
    end
  end
end
