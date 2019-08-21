module Workarea
  module Reports
    class ReviewsByUser
      include Report

      self.reporting_class = Review
      self.sort_fields = %w(reviews verified average_rating activity_score)

      def aggregation
        [filter_results, project_used_fields, group_by_email, project_fields]
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
            'email' => 1,
            'user_id' => 1,
            'rating' => 1,
            'verified' => 1
          }
        }
      end

      def group_by_email
        {
          '$group' => {
            '_id' => '$email',
            'user_id' => { '$max' => '$user_id' },
            'reviews' => { '$sum' => 1 },
            'verified' => { '$sum' => { '$cond' => { 'if' => '$verified', 'then' => 1, 'else' => 0 } } },
            'rating_tally' => { '$sum' => '$rating' }
          }
        }
      end

      def project_fields
        {
          '$project' => {
            'email' => 1,
            'user_id' => 1,
            'reviews' => 1,
            'verified' => 1,
            'average_rating' => { '$divide' => ['$rating_tally', '$reviews'] },
            'activity_score' => { '$sum' => ['$reviews', { '$multiply' => ['$verified', 0.75] }] }
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
