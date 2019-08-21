module Workarea
  module Storefront
    class ReviewRequestsController < Storefront::ApplicationController
      before_action :validate_request
      before_action :find_product, :set_review

      def show; end

      def complete
        if verify_recaptcha(model: @review, env: Rails.env) && @review.save
          @request.complete!
          Review::Request.cancel_for_orders!(@request.order_id)

          flash[:success] = t('workarea.storefront.reviews.flash_messages.created')
          redirect_to product_path(@product)
        else
          flash[:error] = t('workarea.storefront.reviews.flash_messages.failure')
          render :show
        end
      end

      private

      def validate_request
        @request = Review::Request.find_by_token(params[:id])

        if @request.nil? || @request.completed?
          flash[:error] = t('workarea.storefront.review_requests.flash_messages.already_submitted')
          redirect_to(root_path) && (return)
        end
      end

      def find_product
        model = Catalog::Product.find(@request.product_id)
        @product = ProductViewModel.wrap(model, view_model_options)
      end

      def set_review
        @review = ReviewViewModel.wrap(Review.new(review_params))
      end

      def review_params
        ReviewRequestParams.new(
          @request,
          params[:review]&.permit(:rating, :title, :body)&.to_h || {}
        ).to_h
      end
    end
  end
end
