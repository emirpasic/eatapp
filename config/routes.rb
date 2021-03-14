Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # authentication
      post '/login', to: 'users#login'
      get '/login', to: 'users#verify_login'

      # restaurant
      post '/restaurant', to: 'restaurants#create'
      get '/restaurant/:id', to: 'restaurants#read'
      post '/restaurant/:id', to: 'restaurants#update'
      delete '/restaurant/:id', to: 'restaurants#delete'
    end
  end
end
