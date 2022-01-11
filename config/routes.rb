Rails.application.routes.draw do
  resources :posts
  mount_griddler "/email/incoming"

  resources :feeds
  root "feeds#new"
end
