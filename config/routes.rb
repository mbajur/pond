Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  mount SolidErrors::Engine, at: "/errors" if Rails.env.production?
  mount MissionControl::Jobs::Engine, at: "/jobs"

  root "application#root"

  resource :feed, only: [ :show ]
  resource :discover, only: [ :show ], controller: :discover

  resources :users, path: "/", constraints: { id: /@[^\/]+/ } do
    post :follow, on: :member
    delete :unfollow, on: :member

    resources :collections, path: "/", param: :slug, constraints: { slug: /[a-zA-Z0-9-]+/ }
  end

  resources :pins do
    get :url_images, on: :collection
    patch :update_collection, on: :member
    get :secondary_actions, on: :member
  end

  resources :posts, only: [ :show ] do
    get :new_text, on: :collection
    get :new_url, on: :collection
    get :new_image, on: :collection

    get :edit_text, on: :member
    get :edit_url, on: :member

    post :create_text, on: :collection
    patch :update_text, on: :member

    post :create_url, on: :collection
    patch :update_url, on: :member

    post :create_image, on: :collection

    get :context_menu, on: :member

    resource :pins, only: [ :new, :create, :show ]
  end

  resources :collections, only: [ :create, :update, :destroy ], param: :slug do
    post :follow, on: :member
    delete :unfollow, on: :member

    resource :pins, only: [ :new, :create, :show ]
  end

  resource :search, only: [ :show ]

  get :join, to: "sessions#new"
  post :join, to: "sessions#create"
  post "join/verify_auth_code", to: "sessions#verify_auth_code", as: :verify_auth_code
  delete :sign_out, to: "sessions#destroy"
end
