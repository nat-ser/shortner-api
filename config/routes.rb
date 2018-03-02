Rails.application.routes.draw do
  resources :short_urls, only: [:index, :create, :new]
  get "/short_urls/:friendly_id", to: "short_urls#show"
end
