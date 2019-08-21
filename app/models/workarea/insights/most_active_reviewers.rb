module Workarea
  module Insights
    class MostActiveReviewers < Base
      class << self
        def dashboards
          %w(people marketing)
        end

        def generate_monthly!
          results = generate_results
          create!(results: results) if results.present?
        end

        def generate_results
          report
            .results
            .select { |r| r['reviews'] > 0 }
            .take(Workarea.config.insights_users_list_max_results)
            .map { |result| result.merge(email: result['_id']) }
        end

        def report
          Reports::ReviewsByUser.new(
            starts_at: beginning_of_last_month,
            ends_at: end_of_last_month,
            sort_by: 'activity_score',
            sort_direction: 'desc',
            results_filter: 'approved'
          )
        end
      end
    end
  end
end
