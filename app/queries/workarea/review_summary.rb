module Workarea
  class ReviewSummary
    def pending_reviews_count
      @pending_reviews_count ||= Review.pending.count
    end

    def recent_reviews_count
      @recent_reviews_count ||= Review.where(:created_at.gte => 1.day.ago).count
    end
  end
end
