Rails.application.routes.draw do
  mount_griddler "/email/incoming"

  resources :posts, only: [:show]
  resources :feeds, only: [:new, :create, :show]
  root "feeds#new"
end
