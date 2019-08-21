module Workarea
  class CreateReview
    include ActiveModel::Validations

    validate :valid_review
    validates :first_name, :last_name, presence: true

    attr_reader :review, :user, :params

    def self.for(product: nil, user: nil, params: {})
      review = Review.new(
        product_id: product.try(:id),
        user_id: user.try(:id)
      )

      new(review, user: user, params: params)
    end

    def initialize(review, user: nil, params: {})
      @review = review
      @user = user
      @params = params
    end

    def save
      update_user_attributes
      update_attributes

      return false unless valid?
      review.save.tap { |result| update_review_requests if result }
    end

    def verified?
      user_order_ids_with_product.any?
    end

    private

    def user_order_ids_with_product
      return [] unless user.present?

      @user_users_with_product ||=
        Order.placed
             .where(user_id: user.id.to_s)
             .where('items.product_id' => review.product_id)
             .pluck(:id)
    end

    def update_user_attributes
      return if !user.present? || user.public_info.present?
      user.update_attributes(params.slice(:first_name, :last_name))
    end

    def update_attributes
      review.assign_attributes(
        params
          .slice(:rating, :body, :title)
          .merge(
            user_info: user_info,
            first_name: first_name,
            last_name: last_name,
            email: email,
            verified: verified?
          )
      )
    end

    def update_review_requests
      return unless user_order_ids_with_product.any?
      Review::Request.cancel_for_orders!(user_order_ids_with_product)
    end

    def user_info
      return user.public_info if user&.public_info.present?

      "#{first_name&.first} #{last_name&.first}".strip
    end

    def first_name
      params[:first_name].presence || user&.first_name
    end

    def last_name
      params[:last_name].presence || user&.last_name
    end

    def email
      params[:email].presence || user&.email
    end

    def valid_review
      unless review.valid?
        review.errors.each do |attr, error|
          errors.add(attr, error)
        end
      end
    end
  end
end
