Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :create, :show] do
        resources :friendships
      end
      resources :groups, only: [:index, :update, :create, :show] do
        resources :events, except: [:update, :destroy]
      end
      resources :events, only: [:update, :destroy]
      resources :games, only: [:index, :update, :create]
      # resources :events, only: [:index, :update, :create, :show]
      resources :friendships, only: [:create, :destroy]
      get '/users/:id/games', to: 'users#user_games'
      get '/users/:id/groups', to: 'users#user_groups'
      get '/users/:id/events', to: 'users#user_events'
      post '/users/:id/join_group', to: 'users#join_group'
      post '/users/:id/join_event', to: 'users#join_event'
      post '/users/:id/sync', to: 'users#sync_user_games'

      get '/users/:id/friends', to: 'friendships#get_user_friends'
      get '/groups/:id/users', to: 'groups#group_users'
      get '/events/:id/users', to: 'events#event_users'
      post '/login', to: 'auth#create'
      get '/reauth', to: 'auth#show'


    end
  end
end
