module Workarea
  module Search
    class AdminReviews
      include Query
      include AdminIndexSearch
      include AdminSorting
      include Pagination

      document Search::Admin

      def initialize(params = {})
        super(params.merge(type: 'review'))
      end

      def fields
        super + %w(review_text)
      end

      def facets
        super + [
          TermsFacet.new(self, 'state'),
          TermsFacet.new(self, 'rating'),
          TermsFacet.new(self, 'verification')
        ]
      end

      def sort
        result = super || []

        if params[:sort] == Sort.highest_rating.to_s
          result.prepend(Sort.highest_rating.field => Sort.highest_rating.direction)
        elsif params[:sort] == Sort.lowest_rating.to_s
          result.prepend(Sort.lowest_rating.field => Sort.lowest_rating.direction)
        end

        result
      end
    end
  end
end
