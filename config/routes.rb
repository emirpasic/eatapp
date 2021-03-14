Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post "/login", to: "users#login"
      get "/login", to: "users#verify_login"
    end
  end
end
