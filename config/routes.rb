Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :create, :show]
      resources :games, only: [:index, :update, :create]
      get '/users/:id/games', to: 'users#user_games'
      post '/login', to: 'auth#create'
      get '/reauth', to: 'auth#show'
      post '/get_games', to: 'users#get_games'
    end
  end
end
