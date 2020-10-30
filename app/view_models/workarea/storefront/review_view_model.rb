module Workarea
  module Storefront
    class ReviewViewModel < ApplicationViewModel
      def requires_public_info?
        anonymous? || user&.public_info.blank?
      end

      def anonymous?
        model.anonymous? || user.nil?
      end

      def user
        return if model.anonymous?
        return @user if defined?(@user)

        @user = User.find(user_id) rescue nil
      end
    end
  end
end
