Rails.application.routes.draw do
  resources :posts, only: [:show]
  resources :feeds, only: [:new, :create, :show] do
    resources :posts, only: [:index]
  end

  root "feeds#new"
end
