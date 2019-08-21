module Workarea
  class Review
    class Request
      include ApplicationDocument
      include UrlToken

      field :order_id, type: String
      field :user_id, type: String
      field :product_id, type: String

      field :email, type: String

      field :send_after, type: DateTime
      field :sent_at, type: DateTime
      field :completed_at, type: DateTime
      field :canceled_at, type: DateTime

      index(order_id: 1)
      index(send_after: 1, sent_at: 1, canceled_at: 1)

      index(
        { created_at: 1 },
        { expire_after_seconds: Workarea.config.review_request_ttl }
      )

      scope :by_order, ->(order_id) { where(order_id: order_id) }
      scope :ready_to_send, ->(from = Time.current) do
        where(:send_after.lte => from, :sent_at => nil, :canceled_at => nil)
      end

      def self.cancel_for_orders!(order_ids)
        self.in(order_id: Array.wrap(order_ids))
            .where(completed_at: nil)
            .update_all(canceled_at: Time.current)
      end

      def scheduled?
        send_after.present?
      end

      def sent?
        sent_at.present?
      end

      def completed?
        completed_at.present? || canceled?
      end

      def canceled?
        canceled_at.present?
      end

      def complete!
        update_attributes(completed_at: Time.current)
      end

      def send!
        update_attributes(sent_at: Time.current)
      end
    end
  end
end
