require 'test_helper'

module Workarea
  class SendReviewRequestsTest < TestCase
    include TestCase::Mail

    def test_perform
      product = create_product(name: 'Foobar Product')

      requests = Array.new(3) { create_review_request(product_id: product.id) }
      create_review_request(product_id: product.id, send_after: 1.week.from_now)
      create_review_request(product_id: product.id, send_after: Time.current, canceled_at: Time.current)

      SendReviewRequests.new.perform

      requests.each(&:reload)
      assert(requests.all?(&:sent?))

      assert_equal(3, ActionMailer::Base.deliveries.size)

      email = ActionMailer::Base.deliveries.last
      assert_includes(email.to, 'test@workarea.com')
      assert_includes(email.subject, product.name)
      assert_includes(
        email.parts.second.body,
        t('workarea.storefront.email.review_request.link')
      )
    end
  end
end
