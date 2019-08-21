module Workarea
  class Review
    include ApplicationDocument

    field :user_id, type: String
    field :user_info, type: String
    field :first_name, type: String
    field :last_name, type: String
    field :email, type: String
    field :product_id, type: String
    field :rating, type: Integer
    field :title, type: String
    field :body, type: String
    field :approved, type: Boolean, default: false
    field :verified, type: Boolean, default: false

    index(product_id: 1, approved: 1)
    index(approved: 1)
    index(created_at: 1)

    validates :product_id, presence: true
    validates :user_info, presence: true
    validates :body, presence: true
    validates :rating, presence: true,
      numericality: {
        greater_than_or_equal_to: 1,
        less_than_or_equal_to: 5,
        only_integer: true
      }

    validate :user_must_have_spent_money_to_create_review

    before_save :ensure_title

    scope :by_product, ->(id) { where(product_id: id) }
    scope :approved, -> { where(approved: true) }
    scope :pending,  -> { where(approved: false) }

    def self.sorts
      [ Workarea::Sort.pending,
        Workarea::Sort.newest,
        Workarea::Sort.modified,
        Workarea::Sort.title,
        Workarea::Sort.rating ]
    end

    # Get {Mongoid::Criteria} for the reviews for a certain product.
    # Optionally allow including unapproved reviews (for the admin).
    #
    # @param [String] product_id
    # @param [optional, Boolean] allow_unapproved
    # @return [Mongoid::Criteria]
    #
    def self.find_for_product(product_id, allow_unapproved = false)
      criteria = by_product(product_id)
      allow_unapproved ? criteria : criteria.approved
    end

    # Lookup aggregate stats on product reviews for a product.
    #
    # @param [String] product_id
    # @return [Hash]
    #
    def self.find_single_aggregates(product_id)
      stats = by_product(product_id).approved.aggregates(:rating)
      { count: stats['count'] || 0, average: stats['avg'] || 0 }
    end

    # Lookup aggregate review stats on multiple products.
    # Used for show stats on browse/detail.
    #
    # @param [Array<String>] product_ids
    # @return [Hash] results Keys are product IDs, values are stats Hash
    #
    def self.find_aggregates(*product_ids)
      product_ids = Array(product_ids).flatten

      if product_ids.one?
        find_single_aggregates(product_ids.first)
      else
        product_ids.inject({}) do |memo, product_id|
          memo[product_id] = find_single_aggregates(product_id)
          memo
        end
      end
    end

    # Find sort score for a product. Used in the search index for sorting by
    # best reviewed.
    #
    # Balances a small number of ratings with the uncertainty of only having a few ratings.
    # See: http://masanjin.net/blog/how-to-rank-products-based-on-user-input
    #
    # @param [String] product_id
    # @return [Float]
    #
    def self.find_sorting_score(product_id)
      reviews = find_for_product(product_id).to_a
      count = (1..5).each_with_object({}) do |i, memo|
        memo[i] = reviews.select { |r| r.rating == i }.length + 2
      end

      count.sum { |rating, count| rating * count }.to_f / count.values.sum
    end

    def anonymous?
      !user_id.present?
    end

    def ensure_title
      self.title = body.truncate(50) if title.blank?
    end

    def user_must_have_spent_money_to_create_review
      if Workarea.config.require_purchase_to_post_review
        user = User.find(user_id)
        if user.total_spent.to_f.zero?
          err_msg = I18n.t('workarea.storefront.reviews.total_spent_validation')
          errors.add(:user, err_msg)
        end
      end
    end
  end
end
