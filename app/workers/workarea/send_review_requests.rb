module Workarea
  class SendReviewRequests
    include Sidekiq::Worker

    def perform
      Review::Request.ready_to_send.each do |request|
        Storefront::ReviewMailer.review_request(request).deliver_now
        request.send!
      end
    end
  end
end
