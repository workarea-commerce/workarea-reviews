module Workarea
  module Admin
    module Reports
      class ReviewsByProductViewModel < ApplicationViewModel
        def results
          @results ||= model.results.map do |result|
            product = products.detect { |p| p.id == result['_id'] }
            OpenStruct.new(
              { product: product }
                .merge(result)
                .merge(
                  average_rating: result['average_rating'].round(2),
                  weighted_average_rating: result['weighted_average_rating'].round(2)
                )
            )
          end
        end

        def products
          @products ||= Catalog::Product.any_in(
            id: model.results.map { |r| r['_id'] }
          ).to_a
        end
      end
    end
  end
end
