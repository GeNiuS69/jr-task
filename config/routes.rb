# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    resources :posts, only: :create, param: :post_id do
      post 'rate', on: :member

      collection do
        get 'top'
        get 'ips'
      end
    end
  end
end
