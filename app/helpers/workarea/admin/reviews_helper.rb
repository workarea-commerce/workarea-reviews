module Workarea
  module Admin
    module ReviewsHelper
      def reviews_report_filter_options
        [
          [t('workarea.admin.reports.reviews_by_product.filters.all'), nil],
          [t('workarea.admin.reports.reviews_by_product.filters.approved'), 'approved'],
          [t('workarea.admin.reports.reviews_by_product.filters.unapproved'), 'unapproved']
        ]
      end
    end
  end
end
