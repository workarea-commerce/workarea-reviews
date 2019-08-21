require 'test_helper'

module Workarea
  class ReviewTest < Workarea::TestCase
    def product_id
      'PROD1'
    end

    def approved
      @approved ||= create_review(
        product_id: product_id,
        rating: 4,
        approved: true
      )
    end

    def unapproved
      @unapproved ||= create_review(
        product_id: product_id,
        rating: 4,
        approved: false
      )
    end

    def test_find_for_product_returns_approved_reviews
      assert([approved], Review.find_for_product(product_id))
    end

    def test_find_for_product_returns_unapproved_when_arg_is_true
      assert([unapproved, approved], Review.find_for_product(product_id, true))
    end

    def test_find_aggregates_returns_a_hash_data_with_one_product_id
      approved
      assert_equal(
        { count:   1, average: 4 },
        Review.find_aggregates(product_id)
      )
    end

    def test_find_aggregates_returns_a_hash_with_multiple_product_ids
      approved
      product_id_2 = 'PROD2'
      create_review(product_id: product_id_2, rating: 3, approved: true)

      assert_equal(
        {
          product_id   => { count: 1, average: 4 },
          product_id_2 => { count: 1, average: 3 }
        },
        Review.find_aggregates(product_id, product_id_2)
      )
    end

    def test_find_single_aggregates_returns_a_hash_with_zeros_if_no_data
      assert_equal(
        { count: 0, average: 0 },
        Review.find_single_aggregates('does-not-compute')
      )
    end

    def test_find_single_aggregates_returns_a_review_data
      create_review(product_id: product_id, rating: 1)
      create_review(product_id: product_id, rating: 2)
      create_review(product_id: product_id, rating: 3)
      create_review(product_id: product_id, rating: 4)
      create_review(product_id: product_id, rating: 5, approved: false)

      assert_equal(
        { count: 4, average: 2.5 },
        Review.find_single_aggregates(product_id)
      )
    end

    def test_ensure_title
      review = Review.new(
        product_id: '123',
        user_info: 'MD',
        rating: 3,
        body: %(
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Nam in ex viverra, pretium tellus quis, bibendum nisi.
          Praesent luctus viverra.
        ).strip
      )

      review.save!
      assert(review.title.present?)
      assert_equal(review.body.truncate(50), review.title)
    end

    def test_find_sorting_score
      create_review(product_id: 'foo', rating: 4, approved: true)
      create_review(product_id: 'foo', rating: 5, approved: true)
      create_review(product_id: 'foo', rating: 5, approved: true)
      assert_equal(3.38, Review.find_sorting_score('foo').round(2))

      create_review(product_id: 'foo', rating: 1, approved: false)
      assert_equal(3.38, Review.find_sorting_score('foo').round(2))

      create_review(product_id: 'foo', rating: 1, approved: true)
      assert_equal(3.21, Review.find_sorting_score('foo').round(2))
    end
  end
end
