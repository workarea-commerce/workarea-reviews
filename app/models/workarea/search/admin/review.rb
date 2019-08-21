module Workarea
  module Search
    class Admin
      class Review < Search::Admin
        def type
          'review'
        end

        def status
          'active'
        end

        def facets
          super.merge(
            state: state,
            rating: model.rating,
            verification: verification
          )
        end

        def jump_to_text
          nil
        end

        def name
          nil
        end

        def jump_to_position
          6
        end

        def search_text
          [model.product_id, model.user_id]
        end

        def review_text
          [model.title, model.body, product&.name].compact
        end

        def state
          if model.approved?
            I18n.t('workarea.admin.reviews.approved')
          else
            I18n.t('workarea.admin.reviews.pending')
          end
        end

        def verification
          if model.verified?
            I18n.t('workarea.admin.reviews.verified')
          else
            I18n.t('workarea.admin.reviews.unverified')
          end
        end

        def as_document
          super.merge(
            review_text: review_text,
            rating: model.rating
          )
        end

        private

        def product
          @product ||= Catalog::Product.find(model.product_id) rescue nil
        end
      end
    end
  end
end
