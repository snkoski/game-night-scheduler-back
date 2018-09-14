Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :create]
      resources :games, only: [:index, :update, :create]
      post '/login', to: 'auth#create'
      get '/reauth', to: 'auth#show'
    end
  end
end
