module Workarea
  module Storefront
    module ReviewsSchemaOrgHelper
      def product_schema(product, related_products: nil)
        schema = super.merge(
          'review': product.reviews.map do |review|
            {
              '@type': 'Review',
              'author': review.user_info,
              'datePublished': review.created_at.strftime('%Y-%m-%d'),
              'description': review.body,
              'name': review.title,
              'reviewRating': {
                '@type': 'Rating',
                'bestRating': '5',
                'worstRating': '1',
                'ratingValue': review.rating.round(2).to_s
              }
            }
          end
        )

        if product.total_reviews > 0 && product.average_rating.present?
          schema['aggregateRating'] = {
            'reviewCount': product.total_reviews.to_s,
            'ratingValue': product.average_rating.round(2).to_s
          }
        end

        schema
      end
    end
  end
end
