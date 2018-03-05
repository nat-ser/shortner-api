Rails.application.routes.draw do
  resources :short_urls, only: [:index, :create]
  get "/:friendly_id", to: "short_urls#show"
end
