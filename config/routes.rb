Rails.application.routes.draw do

  root 'pages#index'
  devise_for :users, path: '', controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }, path_names: { sign_up: 'sign_up', edit: 'edit_account'}

  devise_scope :user do
    post '/sign_up' => "users/registrations#create"
    patch '/edit_account' => "users/registrations#update"
    put '/edit_account' => "users/registrations#update"
  end


  get 'index' => 'pages#index'
  get 'home' => 'pages#index'
  get 'q/index' =>  redirect('/q')
  get 'u/index' =>  redirect('/u')

  resources :quota, path: 'q', param: :slug
  resources :users, path: 'u'

  # /* Quota redirection rules */
  get 'quota/index' => redirect('/q')
  get "/quota" => redirect('/q')
  get '/quota/new' => redirect('/q/new')
  get '/quota/:slug/edit', to: redirect("/q/%{slug}/edit")
  get '/quota/:slug/edit', to: redirect("/q/%{slug}/edit")

  # /* User redirection rules */
  get 'users/index' => redirect('/u')
  get '/users' => redirect('/u')

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
