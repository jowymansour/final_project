Rails.application.routes.draw do


  root 'cta_schedule#new_search'
  get '/transportation/request' => "cta_schedule#transportation_request"
  get '/train/retrieve_data' => "cta_schedule#train_retrieve"
  get '/train/:id' => "cta_schedule#train_schedule"
  get '/bus/retrieve_data' => "cta_schedule#bus_retrieve"
  get '/bus/:id' => "cta_schedule#bus_schedule"
  get '/directions' => "directions#directions"
  get '/search_directions' => "directions#search_directions"
  get 'add_favorite' => "cta_schedule#add_favorite"

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get 'signup' => 'users#new'
  get 'auth/:provider/callback', to: 'sessions#facebook'

  get '/schedule' => "directions#schedule"
  resources :users

  # If no route match
  #get "*path" => redirect("/")

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
