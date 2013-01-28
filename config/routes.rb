Hydra::Application.routes.draw do

  root :to => "dams_repositories#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  devise_scope :user do 
    match '/users/sign_in', :to => "users/sessions#new", :as => :new_user_session
    match '/users/sign_out', :to => "users/sessions#destroy", :as => :destroy_user_session
  end

  match "/:ark/20775/:id", :to => 'catalog#show', :constraints => { :ark => /ark:/ }, :ark => 'ark:', :as => 'catalog'
  match "/:ark/20775/:id", :to => 'catalog#show', :constraints => { :ark => /ark:/ }, :ark => 'ark:', :as => 'solr_document'


  resources :dams_people, :only => [:show]
  resources :dams_subjects, :only => [:show]

  resources :dams_objects
  resources :dams_repositories
  resources :dams_copyrights
  resources :dams_languages
  resources :dams_vocabs
  resources :dams_assembled_collections
  resources :dams_roles

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
