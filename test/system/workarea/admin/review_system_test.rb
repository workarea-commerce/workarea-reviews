require 'test_helper'

module Workarea
  module Admin
    class ReviewSystemTest < SystemTest
      include Admin::IntegrationTest

      setup :review

      def review
        @review ||= create_review(
          product_id: product.id,
          user_id: user.id,
          rating: 3,
          title: 'Integration Review',
          approved: false
        )
      end

      def user
        @user ||= create_user
      end

      def product
        @product ||= create_product
      end

      def test_managing_reviews
        visit admin.reviews_path
        click_link t('workarea.storefront.reviews.review_for', product: product.name)

        click_button 'save_review'
        assert(page.has_content?('Success'))

        assert(page.has_current_path?(admin.reviews_path))

        click_link t('workarea.storefront.reviews.review_for', product: product.name)
        click_link t('workarea.admin.actions.delete')

        assert(page.has_current_path?(admin.reviews_path))
        refute(page.has_content?('Integration Review'))

        visit admin.activity_path
        assert(
          page.has_content?(
            t('workarea.admin.activities.review_destroy_html', name: 'Integration Review')
          )
        )
      end

      def test_sorting_by_rating
        reviews = Array.new(3) do |i|
          create_review(
            rating: 5 - i,
            product_id: create_product(name: "Test #{i}").id
          )
        end

        visit admin.reviews_path
        assert(page.has_ordered_text?('Test 2', 'Test 1', 'Test 0'))

        select 'Highest Rating', from: :sort
        assert(page.has_ordered_text?('Test 0', 'Test 1', 'Test 2'))

        select 'Lowest Rating', from: :sort
        assert(page.has_ordered_text?('Test 2', 'Test 1', 'Test 0'))
      end

      def test_importing_and_exporting
        reviews = Array.new(2) { |i| create_review(product_id: create_product.id) }
        file = create_tempfile(DataFile::Csv.new.serialize(reviews), extension: 'csv')

        visit admin.reviews_path
        click_link t('workarea.admin.shared.bulk_actions.import')
        attach_file 'import[file]', file.path
        click_button 'create_import'

        assert_current_path(admin.reviews_path)
        assert(page.has_content?('Success'))

        click_button t('workarea.admin.shared.bulk_actions.export')

        Workarea.config.data_file_formats[1..-1].each do |format|
          click_link format.upcase
          assert(page.has_content?(format.upcase))
        end

        fill_in 'export[emails_list]', with: 'bcrouse@weblinc.com'
        click_button 'create_export'

        assert_current_path(admin.reviews_path)
        assert(page.has_content?('Success'))
      end
    end
  end
end
