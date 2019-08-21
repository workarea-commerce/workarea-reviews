module Workarea
  module Reviews
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Reviews

      config.to_prepare do
        Storefront::ApplicationController.helper(Storefront::ReviewsHelper)
      end
    end
  end
end
