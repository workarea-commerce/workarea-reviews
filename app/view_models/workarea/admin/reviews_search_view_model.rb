module Workarea
  module Admin
    class ReviewsSearchViewModel < SearchViewModel
      def results
        @results ||= PagedArray.from(
          persisted_results.map do |review|
            ReviewViewModel.new(
              review,
              product: products.detect { |p| p.id.to_s == review.product_id.to_s }
            )
          end,
          model.results.page,
          model.results.per_page,
          total
        )
      end

      def sort
        if options[:sort] == Sort.highest_rating.to_s
          Sort.highest_rating.to_s
        elsif options[:sort] == Sort.lowest_rating.to_s
          Sort.lowest_rating.to_s
        else
          super
        end
      end

      def sorts
        super + [
          Sort.highest_rating.to_a,
          Sort.lowest_rating.to_a
        ]
      end

      private

      def products
        @products ||= ProductViewModel.wrap(
          Catalog::Product
            .any_in(id: persisted_results.map(&:product_id))
            .map { |product| Admin::ProductViewModel.new(product) }
        )
      end
    end
  end
end
