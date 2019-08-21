module Workarea
  module Storefront
    module ReviewsHelper
      def rating_stars(rating, options = {})
        full_star_count = rating.floor
        empty_star_count = 5 - rating.ceil
        half_star_size = (rating % 1).round(2) * 100
        half_star_width = 20 + (half_star_size - 0) * (80.0 - 20) / (100.0 - 0)

        render 'workarea/storefront/products/rating', rating: rating, full_star_count: full_star_count, empty_star_count: empty_star_count, half_star_width: half_star_width, half_star_size: half_star_size
      end

      def display_purchase_requirement_message
        if current_user && Workarea.config.require_purchase_to_post_review && current_user.total_spent.to_f.zero?
          true
        else
          false
        end
      end
    end
  end
end
