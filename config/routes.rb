Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :create, :show]
      resources :games, only: [:index, :update, :create]
      resources :groups, only: [:index, :update, :create, :show]
      get '/users/:id/games', to: 'users#user_games'
      get '/users/:id/groups', to: 'users#user_groups'
      post '/get_games', to: 'users#get_games'
      get '/groups/:id/users', to: 'groups#group_users'
      post '/login', to: 'auth#create'
      get '/reauth', to: 'auth#show'


    end
  end
end
