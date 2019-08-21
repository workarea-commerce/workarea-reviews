module Workarea
  module Factories
    module Reviews
      Factories.add(self)

      def create_review(overrides = {})
        attributes = {
          title: 'Test Product',
          body: 'This is great.',
          product_id: "PROD#{rand(9_999_999)}",
          user_id: BSON::ObjectId.new,
          approved: true,
          rating: 4,
          user_info: 'BC from Philadelphia'
        }.merge(overrides)

        Workarea::Review.create!(attributes)
      end

      def create_review_request(overrides = {})
        attributes = {
          product_id: "PROD#{rand(9_999_999)}",
          order_id: SecureRandom.hex(5).upcase,
          email: 'test@workarea.com',
          send_after: Time.current
        }.merge(overrides)

        Workarea::Review::Request.create!(attributes)
      end
    end
  end
end
