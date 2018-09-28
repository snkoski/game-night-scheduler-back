Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :create, :show] do
        resources :friendships
      end
      resources :games, only: [:index, :update, :create]
      resources :groups, only: [:index, :update, :create, :show]
      resources :friendships, only: [:create, :destroy]
      get '/users/:id/games', to: 'users#user_games'
      get '/users/:id/groups', to: 'users#user_groups'
      post '/users/:id/join_group', to: 'users#join_group'
      post '/users/:id/sync', to: 'users#sync_user_games'

      get '/users/:id/friends', to: 'friendships#get_user_friends'
      get '/groups/:id/users', to: 'groups#group_users'
      post '/login', to: 'auth#create'
      get '/reauth', to: 'auth#show'


    end
  end
end
