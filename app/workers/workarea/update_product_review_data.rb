module Workarea
  class UpdateProductReviewData
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options(
      enqueue_on: {
        Workarea::Review => [:save, :destroy],
        with: -> { [product_id] }
      },
      unique: :until_and_while_executing
    )

    def perform(product_id)
      product = Workarea::Catalog::Product.find(product_id)
      review_data = Review.find_single_aggregates(product_id)

      product.update_attributes!(
        total_reviews: review_data[:count],
        average_rating: review_data[:average]
      )
    rescue Mongoid::Errors::DocumentNotFound
      # we're ok if the product doesn't exist
    end
  end
end
