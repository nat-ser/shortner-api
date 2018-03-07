Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      resources :short_urls, only: [:index, :create]
      get "/:friendly_id", to: "short_urls#show", as: :friendly
    end
  end
end
