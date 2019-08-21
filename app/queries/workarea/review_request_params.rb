module Workarea
  class ReviewRequestParams
    attr_reader :request, :params

    def initialize(request, params)
      @request = request
      @params = params
    end

    def to_h
      params.merge(
        product_id: @request.product_id,
        user_id: @request.user_id,
        email: @request.email,
        user_info: user_info,
        first_name: first_name,
        last_name: last_name,
        verified: true
      )
    end

    private

    def user_info
      return user.public_info if user&.public_info.present?

      [first_name.first, last_name.first].join
    end

    def first_name
      user&.first_name || billing_address.first_name
    end

    def last_name
      user&.last_name || billing_address.last_name
    end

    def user
      return nil unless @request.user_id.present?
      @user ||= User.find(@request.user_id)
    end

    def billing_address
      @billing_address ||= Payment.find(@request.order_id).address
    end
  end
end
