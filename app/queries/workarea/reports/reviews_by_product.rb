module Workarea
  module Reports
    class ReviewsByProduct
      include Report

      self.reporting_class = Review
      self.sort_fields = %w(reviews verified average_rating weighted_average_rating)

      def aggregation
        [filter_results, project_used_fields, group_by_product, project_averages]
      end

      def filter_results
        {
          '$match' => {
            'created_at' => { '$gte' => starts_at, '$lte' => ends_at },
            **approval_query
          }
        }
      end

      def project_used_fields
        {
          '$project' => {
            'product_id' => 1,
            'rating' => 1,
            'verified' => 1
          }
        }
      end

      def group_by_product
        {
          '$group' => {
            '_id' => '$product_id',
            'reviews' => { '$sum' => 1 },
            'verified' => { '$sum' => { '$cond' => { 'if' => '$verified', 'then' => 1, 'else' => 0 } } },
            'rating_tally' => { '$sum' => '$rating' },
            'rated_5' => { '$sum' => { '$cond' => { 'if' => { '$eq' => ['$rating', 5] }, 'then' => 1, 'else' => 0 } } },
            'rated_4' => { '$sum' => { '$cond' => { 'if' => { '$eq' => ['$rating', 4] }, 'then' => 1, 'else' => 0 } } },
            'rated_3' => { '$sum' => { '$cond' => { 'if' => { '$eq' => ['$rating', 3] }, 'then' => 1, 'else' => 0 } } },
            'rated_2' => { '$sum' => { '$cond' => { 'if' => { '$eq' => ['$rating', 2] }, 'then' => 1, 'else' => 0 } } },
            'rated_1' => { '$sum' => { '$cond' => { 'if' => { '$eq' => ['$rating', 1] }, 'then' => 1, 'else' => 0 } } }
          }
        }
      end

      def project_averages
        {
          '$project' => {
            'product_id' => 1,
            'reviews' => 1,
            'verified' => 1,
            'average_rating' => { '$divide' => ['$rating_tally', '$reviews'] },
            'weighted_average_rating' => {
              '$divide' => [
                {
                  '$sum' => [
                    { '$multiply' => [{ '$sum' => [2, '$rated_5'] }, 5] },
                    { '$multiply' => [{ '$sum' => [2, '$rated_4'] }, 4] },
                    { '$multiply' => [{ '$sum' => [2, '$rated_3'] }, 3] },
                    { '$multiply' => [{ '$sum' => [2, '$rated_2'] }, 2] },
                    { '$multiply' => [{ '$sum' => [2, '$rated_1'] }, 1] }
                  ]
                },
                { '$sum' => [10, '$rated_5', '$rated_4', '$rated_3', '$rated_2', '$rated_1'] }
              ]
            }
          }
        }
      end

      private

      def approval_query
        if params[:results_filter] == 'approved'
          { approved: true }
        elsif params[:results_filter] == 'unapproved'
          { approved: false }
        else
          {}
        end
      end
    end
  end
end
