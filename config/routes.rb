Rails.application.routes.draw do
  
  root "jobs#index"
  resources :jobs
  resources :users

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
  
end
