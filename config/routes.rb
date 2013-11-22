RecommenderApp::Application.routes.draw do

  resources :recommendations

  root 'sessions#index'

  get '/test' => 'users#test'

  get '/about' => 'admin#about', :as => :about
  get '/login' => 'sessions#login'
  get '/sessions' => 'sessions#index'
  get '/sessions/page' => 'sessions#page'
  get '/sessions' => 'sessions#index'
  get '/sessions/show' => 'sessions#show'
  get '/sessions/logout' => 'sessions#logout', :as => :logout

  get '/users/create' => 'users#create', :as => :create_user
  post '/users/adjust_score' => 'users#adjust_score', :as => :adjust_score

  get '/admin' => 'admin#index', :as => :admin 
  get '/admin/results' => 'admin#results', :as => :results
  post '/admin' => 'admin#reset'

  resources :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
