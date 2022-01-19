Rails.application.routes.draw do
  mount_griddler "/email/incoming"

  resources :posts, only: [:show]
  resources :feeds, only: [:new, :create, :show] do
    resources :posts, only: [:index]
  end

  scope as: "subdomain", constraints: {subdomain: /.+/} do
    root to: "feeds#show"
    get "feed", to: "feeds#show", constraints: {format: :atom}
    get "posts", to: "posts#index"
  end

  get "favicon", to: "feeds#favicon", constraints: {format: :ico}
  root to: "feeds#new"
end
