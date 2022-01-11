Rails.application.routes.draw do
  mount_griddler "/email/incoming"

  resources :feeds
  root "feeds#new"
end
