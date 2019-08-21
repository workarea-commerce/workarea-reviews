require 'test_helper'

module Workarea
  module Admin
    class ReviewsByProductSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_report
        create_product(id: 'foo', name: 'Foo')

        create_review(product_id: 'foo', rating: 4, approved: false)
        create_review(product_id: 'foo', rating: 3)
        create_review(product_id: 'bar', rating: 1, approved: false)
        create_review(product_id: 'bar', rating: 1, approved: false)
        create_review(product_id: 'bar', rating: 2)
        create_review(product_id: 'bar', rating: 2, approved: false)

        visit admin.reviews_by_product_report_path
        assert(page.has_content?('Foo'))
        assert(page.has_content?('bar'))
        assert(page.has_content?('2'))
        assert(page.has_content?('3.5'))
        assert(page.has_content?('3.08'))
        assert(page.has_content?('4'))
        assert(page.has_content?('1.5'))
        assert(page.has_content?('2.5'))

        click_link t('workarea.admin.fields.average_rating')
        assert(page.has_content?("#{t('workarea.admin.fields.average_rating')} ↓"))
        assert(page.has_ordered_text?('Foo', 'bar'))

        click_link t('workarea.admin.fields.reviews')
        assert(page.has_content?("#{t('workarea.admin.fields.reviews')} ↓"))
        assert(page.has_ordered_text?('bar', 'Foo'))

        click_link t('workarea.admin.fields.reviews')
        assert(page.has_content?("#{t('workarea.admin.fields.reviews')} ↑"))
        assert(page.has_ordered_text?('Foo', 'bar'))

        select t('workarea.admin.reports.reviews_by_product.filters.unapproved'), from: :results_filter

        assert(page.has_content?('Foo'))
        assert(page.has_content?('1'))
        assert(page.has_content?('4'))
        assert(page.has_content?('bar'))
        assert(page.has_content?('3'))
        assert(page.has_content?('1.33'))

        select t('workarea.admin.reports.reviews_by_product.filters.approved'), from: :results_filter

        assert(page.has_content?('Foo'))
        assert(page.has_content?('1'))
        assert(page.has_content?('3'))
        assert(page.has_content?('bar'))
        assert(page.has_content?('1'))
        assert(page.has_content?('2'))
      end
    end
  end
end
