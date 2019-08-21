require 'test_helper'

module Workarea
  class CreateReviewTest < TestCase
    setup :user, :product

    def user
      @user ||= create_user
    end

    def product
      @product ||= create_product
    end

    def test_for
      create = CreateReview.for(user: user, product: product)

      assert_equal(user.id.to_s, create.review.user_id)
      assert_equal(product.id.to_s, create.review.product_id)
      assert(create.user.present?)
    end

    def test_save
      create = CreateReview.for(user: user, product: product)
      refute(create.save)
      assert(create.errors[:body].present?)
      assert(create.errors[:rating].present?)

      create = CreateReview.for(
        user: user,
        product: product,
        params: { body: 'foo bar', rating: 3 }
      )
      assert(create.save)

      create = CreateReview.for(
        product: product,
        params: { body: 'foo bar', rating: 3 }
      )
      refute(create.save)
      assert(create.errors[:first_name].present?)
      assert(create.errors[:last_name].present?)

      create = CreateReview.for(
        product: product,
        params: {
          body: 'foo bar',
          rating: 3,
          first_name: 'Bob',
          last_name: 'Clams'
        }
      )
      assert(create.save)
    end

    def test_verified?
      create_order(
        user_id: user.id,
        email: user.email,
        placed_at: Time.now,
        items: [{ product_id: product.id, sku: product.skus.first, quantity: 1 }]
      )

      create = CreateReview.for(
        user: user,
        product: product,
        params: { body: 'foobar', rating: 4 }
      )

      assert(create.verified?)
      assert(create.save)
      assert(create.review.verified?)
    end

    def test_canceling_review_requests
      order = create_order(
        user_id: user.id,
        email: user.email,
        placed_at: Time.now,
        items: [{ product_id: product.id, sku: product.skus.first, quantity: 1 }]
      )

      review_request = create_review_request(
        user_id: user.id,
        product_id: product.id,
        order_id: order.id
      )

      CreateReview.for(user: user, product: product, params: {}).save
      refute(review_request.reload.canceled?)

      CreateReview.for(
        user: user,
        product: product,
        params: { body: 'foobar', rating: 4 }
      ).save

      assert(review_request.reload.canceled?)
    end

    def test_title
      create_with_title = CreateReview.for(
        product: product,
        params: {
          title: 'Baz',
          body: 'foo bar',
          rating: 3,
          first_name: 'Bob',
          last_name: 'Clams'
        }
      )
      create_without_title = CreateReview.for(
        product: product,
        params: {
          body: 'foo bar',
          rating: 3,
          first_name: 'Bob',
          last_name: 'Clams'
        }
      )

      assert(create_with_title.save)
      assert_equal('Baz', create_with_title.review.title)
      assert_equal('foo bar', create_with_title.review.body)

      assert(create_without_title.save)
      assert_equal('foo bar', create_without_title.review.title)
      assert_equal('foo bar', create_without_title.review.body)
    end
  end
end
