Rails.application.routes.draw do

get 'books/new'
get 'users/new'


get 'sessions/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#home'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get    'search'   => 'users#search'
  get    'users/search'   => 'users#search_user'
  get    'users/delete_member'   => 'users#delete_member'
  delete 'users/delete_member/:id'  => 'users#destroy_member'
  get    'users/search_checkout_history'   => 'users#search_checkout_history'
  get    'users/checkout_history'   => 'users#checkout_history'
  get    'users/checkout_history/:id'   => 'users#checkout_history'
  get    'users/view_profile'   => 'users#view_profile'
  get    'users/edit'   => 'users#edit'  
  post   'users/edit'   => 'users#update'  
  get    'users/change_pass'   => 'users#change_pass'
  post   'users/change_pass'   => 'users#update_pass'
  get	 'users/checkout'   => 'users#checkout'
  get    'users/suggest'   => 'users#suggest'
  get    'users/return'   => 'users#return'
  resources :users
  resources :books
  get    'books/:id/checkout'   => 'books#checkout'
  get    'books/:id/return'   => 'books#return'
  get    'books/:id/setalert'   => 'books#set_alert'
  get    'books/:id/checkout_history'   => 'books#checkout_history'

  resources :suggestions

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
