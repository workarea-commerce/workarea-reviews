module Workarea
  module Storefront
    class ReviewsController < Storefront::ApplicationController
      before_action :find_product
      before_action :set_review

      def new; end

      def create
        if review_can_be_saved? && @create_review.save
          redirect_to product_path(params[:product_id])
          flash[:success] = t('workarea.storefront.reviews.flash_messages.created')
        else
          render :new
          flash[:error] = t('workarea.storefront.reviews.flash_messages.failure')
        end
      end

      private

      def set_review
        @create_review = CreateReview.for(
          product: @product,
          user: current_user,
          params: review_params.to_h
        )

        @review = ReviewViewModel.wrap(@create_review.review)
      end

      def find_product
        @product ||=
          begin
            model = Catalog::Product.find_by(slug: params[:product_id])
            raise InvalidDisplay unless model.active? || current_user.try(:admin?)
            ProductViewModel.wrap(model)
          end
      end

      def review_params
        return {} unless params[:review].present?

        params[:review].permit(
          :product_id, :rating, :title, :body, :first_name, :last_name, :email
        )
      end

      def review_can_be_saved?
        verify_recaptcha(model: @create_review, env: Rails.env)
      end
    end
  end
end
