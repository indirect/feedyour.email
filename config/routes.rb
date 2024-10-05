Rails.application.routes.draw do
  resources :posts, only: [:show]
  resources :feeds, only: [:new, :create, :show] do
    resources :posts, only: [:index] do
      collection { get :search }
    end
  end
  resources :stats, only: [:index]

  get "up" => "rails/health#show"

  root "feeds#new"
end
