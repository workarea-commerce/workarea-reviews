module Workarea
  class Admin::ReviewsController < Admin::ApplicationController
    required_permissions :marketing
    before_action :find_review, except: :index

    def index
      search = Search::AdminReviews.new(params.merge(autocomplete: request.xhr?))
      @search = Admin::ReviewsSearchViewModel.new(search, view_model_options)
    end

    def show
      redirect_to edit_review_path(@review)
    end

    def edit; end

    def update
      if @review.update_attributes(review_params)
        flash[:success] = t('workarea.admin.reviews.flash_messages.updated')
        redirect_to reviews_path
      else
        render :edit
      end
    end

    def destroy
      @review.destroy
      flash[:success] = t('workarea.admin.reviews.flash_messages.destroyed')
      if params[:product].present?
        redirect_to reviews_catalog_product_path(params[:product])
      else
        redirect_to reviews_path
      end
    end

    private

    def find_review
      if params[:id].present?
        review = Review.find(params[:id])
        @review = Admin::ReviewViewModel.wrap(review)
        @user = User.find(review.user_id) rescue nil
      end
    end

    def review_params
      return {} if params[:review].blank?
      params[:review].permit(:body, :approved, :rating, :title)
    end
  end
end
