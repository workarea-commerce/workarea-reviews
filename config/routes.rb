Workarea::Admin::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :reviews, except: [:new, :create]
    resources :catalog_products, only: [] do
      member do
        get :reviews
      end
    end

    resource :report, only: [] do
      get :reviews_by_product
    end
  end
end

Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    get 'reviews/:product_id/new' => 'reviews#new', as: :new_product_review
    post 'reviews/:product_id' => 'reviews#create', as: :create_product_review

    resources :review_requests, only: :show do
      member { post :complete }
    end
  end
end
