module Workarea
  module Admin
    module ReviewsHelper
      def reviewer_info(model)
        return model.user_info unless model.user_id.present?

        link_to model.user_info,
                edit_user_path(model.user_id)
      end
    end
  end
end
