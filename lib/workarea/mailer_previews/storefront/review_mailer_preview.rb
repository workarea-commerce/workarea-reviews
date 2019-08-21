module Workarea
  module Storefront
    class ReviewMailerPreview < ActionMailer::Preview
      def review_request
        request = Review::Request.ready_to_send.first || Review::Request.first
        ReviewMailer.review_request(request.id.to_s)
      end
    end
  end
end
