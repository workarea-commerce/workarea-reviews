module Workarea
  module Storefront
    class ReviewMailer < Storefront::ApplicationMailer
      include TransactionalMailer

      def review_request(request_id)
        @request = Review::Request.find(request_id)
        @content = Content::Email.find_content('review_request')
        @product = Storefront::ProductViewModel.wrap(
          Catalog::Product.find(@request.product_id)
        )

        mail(
          to: @request.email,
          subject: t(
            'workarea.storefront.email.review_request.subject',
            product: @product.name
          )
        )
      end
    end
  end
end
