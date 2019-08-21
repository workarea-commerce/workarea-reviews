module Workarea
  #
  # Storefront
  #
  #

  Plugin.append_stylesheets(
    'storefront.components',
    'workarea/storefront/reviews/components/rating',
    'workarea/storefront/reviews/components/reviews',
    'workarea/storefront/reviews/components/reviews_aggregate',
    'workarea/storefront/reviews/components/write_review',
  )

  Plugin.append_javascripts(
    'storefront.templates',
    'workarea/storefront/reviews/templates/sort_by_property'
  )

  Plugin.append_javascripts(
    'storefront.modules',
    'workarea/storefront/reviews/modules/product_review_ajax_submit',
    'workarea/storefront/reviews/modules/product_reviews_sort_menus',
    'workarea/storefront/reviews/modules/rating_buttons',
  )

  Plugin.append_partials(
    'storefront.style_guide_product_summary',
    'workarea/storefront/style_guides/reviews_product_summary_docs'
  )

  Plugin.append_partials(
    'storefront.product_details',
    'workarea/storefront/products/reviews_aggregate'
  )

  Plugin.append_partials(
    'storefront.product_show',
    'workarea/storefront/products/reviews'
  )

  Plugin.append_partials(
    'storefront.product_summary',
    'workarea/storefront/products/reviews_summary'
  )

  #
  # Admin
  #
  #
  Plugin.append_partials(
    'admin.marketing_menu',
    'workarea/admin/reviews/menu'
  )

  Plugin.append_partials(
    'admin.catalog_product_aux_navigation',
    'workarea/admin/reviews/catalog_products_aux_link'
  )

  Plugin.append_partials(
    'admin.status_report_mailer',
    'workarea/admin/status_report_mailer/reviews'
  )

  Workarea.append_partials(
    'admin.marketing_dashboard_navigation',
    'workarea/admin/reviews/dashboard_navigation'
  )
end
