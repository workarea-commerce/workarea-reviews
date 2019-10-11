module Workarea
  class ReviewSeeds
    def perform
      puts 'Adding reviews...'

      Sidekiq::Callbacks.disable do
        create_reviews_for_catalog
        create_review_request_email_content
      end
    end

    private

    def create_reviews_for_catalog
      Workarea::Catalog::Product.all.each_by(100) do |product|
        reviews = Array.new(rand(10)) { create_review(product) }
        next unless reviews.size > 0

        Workarea::Review.collection.insert_many(reviews.map(&:as_document))
        UpdateProductReviewData.perform_async(product.id)
      end
    end

    def create_review(product)
      Workarea::Review.new(
        product_id: product.id,
        user_id: BSON::ObjectId.new,
        rating: rand(5) + 1,
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph,
        approved: [true, false].sample,
        user_info: Faker::Internet.user_name,
        verified: [true, false].sample,
        created_at: rand(45).days.ago,
        updated_at: Time.current
      )
    end

    def create_review_request_email_content
      Content::Email.create!(
        type: 'review_request',
        content: <<~HTML
          <h1>Let us know what you think!</h1>
          <p>Your feedback is important to us.</p>
        HTML
      )
    end
  end
end
