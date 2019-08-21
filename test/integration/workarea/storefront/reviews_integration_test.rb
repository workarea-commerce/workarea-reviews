require 'test_helper'

module Workarea
  module Storefront
    class ReviewsIntegrationTest < Workarea::IntegrationTest
      def user
        @user ||= create_user(
          email: 'test@weblinc.com',
          password: 'w3bl1nc',
          first_name: 'Bob',
          last_name: 'Clams',
        )
      end

      def product
        @product ||= create_product
      end

      def login
        post storefront.login_path,
             params: {
               email: user.email,
               password: 'w3bl1nc'
             }
      end

      def test_creating_a_review
        login

        post storefront.create_product_review_path(product),
             params: {
               review: {
                 product_id: product.id,
                 rating: 1,
                 title: 'Amazing product',
                 body: 'Totes buy this product!'
               }
             }

        assert_redirected_to(storefront.product_path(product))

        assert_equal(
          I18n.t('workarea.storefront.reviews.flash_messages.created'),
          flash[:success]
        )
      end

      def test_creating_a_review_not_signed_in
        post storefront.create_product_review_path(product),
             params: {
               review: {
                 product_id: product.id,
                 rating: 1,
                 title: 'Amazing product',
                 body: 'Totes buy this product!',
                 first_name: 'Bob',
                 last_name: 'Clams'
               }
             }

        assert_redirected_to(storefront.product_path(product))

        assert_equal(
          I18n.t('workarea.storefront.reviews.flash_messages.created'),
          flash[:success]
        )
      end

      def test_create_failure
        login

        post storefront.create_product_review_path(product)

        assert_equal(200, status)
        assert_equal(
          I18n.t('workarea.storefront.reviews.flash_messages.failure'),
          flash[:error]
        )
      end
    end
  end
end
