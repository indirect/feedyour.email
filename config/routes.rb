Rails.application.routes.draw do
  resources :posts, only: [:show]
  resources :feeds, only: [:new, :create, :show] do
    resources :posts, only: [:index] do
      collection { get :search }
    end
  end
  resources :stats, only: [:index]

  root "feeds#new"
end
