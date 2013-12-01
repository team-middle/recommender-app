RecommenderApp::Application.routes.draw do

  # resources :recommendations

  root 'sessions#index'

  get '/test' => 'users#test'

  get '/auth/facebook/callback' => 'sessions#create'
  get '/sessions/create' => 'sessions#create'
  get '/auth/failure' => 'sessions#index'
  get '/sessions/logout' => 'sessions#destroy', :as => :logout
  
  get '/about' => 'admin#about', :as => :about
  # get '/auth/facebook' => 'sessions#create', :as => :login
  get '/sessions' => 'sessions#index'
  get '/sessions/page' => 'sessions#page'
  get '/sessions/show' => 'sessions#show'

  get '/users/create' => 'users#create', :as => :create_user
  post '/users/adjust_score' => 'users#adjust_score', :as => :adjust_score
  post '/follow' => 'users#follow', :as => :follow
  post '/users/delete_saved' => 'users#delete_saved', :as => :delete_saved

  get '/admin' => 'admin#index', :as => :admin 
  get '/admin/results' => 'admin#results', :as => :results
  # post '/admin' => 'admin#reset'


  get '/recommendations' => 'recommendations#create', :as => :recommendations

  resources :users, :only => [:show]

end
