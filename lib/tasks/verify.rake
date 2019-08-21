namespace :workarea do
  namespace :reviews do
    desc 'Assign verified to each review based on whether the user has any orders with the product being reviewed'
    task verify: :environment do
      Workarea::Review.all.each_by(100) do |review|
        user = Workarea::User.find(review.user_id) rescue nil

        next unless user.present?

        creator = Workarea::CreateReview.new(review, user: user)

        review.update!(verified: creator.verified?)
      end
    end
  end
end
