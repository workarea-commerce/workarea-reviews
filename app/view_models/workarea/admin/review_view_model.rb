module Workarea
  module Admin
    class ReviewViewModel < ApplicationViewModel
      delegate :primary_image, to: :product, allow_nil: true

      def name
        if product.present?
          t('workarea.admin.reviews.index.review_for', product: product.name)
        else
          t('workarea.admin.reviews.index.review')
        end
      end

      def product
        @product ||=
          options[:product] ||
          ProductViewModel.wrap(Catalog::Product.find(product_id))
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end
    end
  end
end
