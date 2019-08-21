module Workarea
  module Admin
    class ImportReviewsController < Admin::ApplicationController
      required_permissions :marketing

      def new
        @import = Import::Review.new
      end

      def create
        @import = Import::Review.new(import_params)

        if @import.save
          ProcessImport.perform_async(@import.to_global_id)

          flash[:success] = t('workarea.admin.import_reviews.flash_messages.processing')
          redirect_to reviews_path
        else
          render :new, status: :unprocessable_entity
        end
      end

      def sample
        send_file Reviews::Engine.root.join('public/workarea/import_samples/reviews.csv')
      end

      private

      def import_params
        params.fetch(:import_review, {})
              .merge(created_by_id: current_user.id)
      end
    end
  end
end
