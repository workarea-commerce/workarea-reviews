module Workarea
  class ReviewSeeds
    def perform
      puts 'Adding reviews...'

      Workarea::Catalog::Product.all.each_by(100) do |product|
        rand(10).times { create_review(product) }
      end

      create_review_request_email_content
    end

    private

    def create_review(product)
      user = rand(3) < 2 ? Workarea::User.sample : nil

      Workarea::Review.create!(
        product_id: product.id,
        user_id: user&.id,
        rating: rand(5) + 1,
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph,
        approved: [true, false].sample,
        user_info: user&.name || Faker::Internet.user_name,
        email: user&.email || Faker::Internet.email,
        verified: [true, false].sample,
        created_at: (3..30).to_a.sample.days.ago
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
