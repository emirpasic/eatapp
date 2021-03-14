Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      # authentication (JWT)
      post '/login', to: 'users#login'
      get '/login', to: 'users#verify_login'

      # restaurant
      post '/restaurant', to: 'restaurants#create'
      get '/restaurant/:id', to: 'restaurants#read'
      post '/restaurant/:id', to: 'restaurants#update'
      delete '/restaurant/:id', to: 'restaurants#delete'

      # guest
      post '/guest', to: 'guest_users#create'
      get '/guest/:id', to: 'guest_users#read'
      post '/guest/:id', to: 'guest_users#update'
      delete '/guest/:id', to: 'guest_users#delete'

      # reservations
      post '/reservation', to: 'reservations#create'
      get '/reservation/:id', to: 'reservations#read'
      post '/reservation/:id', to: 'reservations#update'
      delete '/reservation/:id', to: 'reservations#delete'

    end
  end
end
