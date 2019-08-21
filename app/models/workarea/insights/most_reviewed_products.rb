module Workarea
  module Insights
    class MostReviewedProducts < Base
      class << self
        def dashboards
          %w(marketing)
        end

        def generate_monthly!
          results = generate_results
          create!(results: results) if results.present?
        end

        def generate_results
          report
            .results
            .select { |r| r['reviews'] > 0 }
            .take(Workarea.config.insights_products_list_max_results)
            .map { |result| result.merge(product_id: result['_id']) }
        end

        def report
          Reports::ReviewsByProduct.new(
            starts_at: beginning_of_last_month,
            ends_at: end_of_last_month,
            sort_by: 'reviews',
            sort_direction: 'desc'
          )
        end
      end
    end
  end
end
