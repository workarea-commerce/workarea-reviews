module Workarea
  module Storefront
    class ReviewViewModel < ApplicationViewModel
      def requires_public_info?
        anonymous? || user.public_info.blank?
      end

      def user
        return if anonymous?
        @user ||= User.find(user_id)
      end
    end
  end
end
