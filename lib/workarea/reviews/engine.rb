module Workarea
  module Reviews
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Reviews

      config.to_prepare do
        Admin::ApplicationController.helper(Admin::ReviewsHelper)
        Storefront::ApplicationController.helper(Storefront::ReviewsHelper)
        Workarea::Storefront::ApplicationController.helper(
          Workarea::Storefront::ReviewsSchemaOrgHelper
        )
      end
    end
  end
end
