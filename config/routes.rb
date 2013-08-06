Hydra::Application.routes.draw do


  # Static page routes
  match '/faq', to: 'static_pages#faq'
  match '/about', to: 'static_pages#about'
  match '/zotero', to: 'static_pages#zotero'
  match '/mendeley', to: 'static_pages#mendeley'


  #resources :units, :only => [:index, :show]
  root :to => "dams_units#index"
  resources :dams_collections, :only => [:index, :show]
  match '/dlp', to: 'dams_units#show', :id => 'dlp'
  match '/rci', to: 'dams_units#show', :id => 'rci'
  match '/:id/collections', to: 'dams_units#collections', :as => "dams_unit_collections"

  Blacklight.add_routes(self, :except => [:solr_document, :catalog]  )

  # add Blacklight catalog -> search routing
  # Catalog stuff.
  match 'search/opensearch', :as => "opensearch_catalog"
  match 'search/citation', :as => "citation_catalog"
  match 'search/email', :as => "email_catalog"
  match 'search/sms', :as => "sms_catalog"
  match 'search/endnote', :as => "endnote_catalog"
  match 'search/send_email_record', :as => "send_email_record_catalog"
  match "search/facet/:id", :to => 'catalog#facet', :as => 'catalog_facet'
  match "search", :to => 'catalog#index', :as => 'catalog_index'
  match 'search/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_catalog"
  resources :solr_document,  :path => 'search', :controller => 'catalog', :only => [:show, :update]
  # :show and :update are for backwards-compatibility with catalog_url named routes
  resources :catalog, :only => [:show, :update]


  HydraHead.add_routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    match '/users/sign_in', :to => "users/sessions#new", :as => :new_user_session
    match '/users/sign_out', :to => "users/sessions#destroy", :as => :destroy_user_session
  end

  match "/:ark/20775/:id", :to => 'catalog#show', :constraints => { :ark => /ark:/ }, :ark => 'ark:', :as => 'catalog'
  match "/:ark/20775/:id", :to => 'catalog#show', :constraints => { :ark => /ark:/ }, :ark => 'ark:', :as => 'solr_document'

  resources :dams_subjects, :only => [:show]

  resources :object, :controller => 'dams_objects', :as => 'dams_objects' do
    get 'view', :on => :member
  end

  match "object/:id/upload", :to => 'file#create', :as => 'upload'
  match "object/:id/deriv/:ds", :to => 'file#deriv', :as => 'deriv'
  match "object/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
  resources :dams_assembled_collections
  resources :dams_units do
    member do
      get 'view'
      get 'collections'
    end
  end
  resources :dams_copyrights
  resources :dams_licenses
  resources :dams_other_rights
  resources :dams_statutes
  resources :dams_languages
  resources :dams_vocabularies
  resources :dams_roles
  resources :dams_provenance_collections
  resources :dams_provenance_collection_parts
  resources :dams_vocabulary_entries
  resources :dams_source_captures
  resources :dams_cartographics
  resources :dams_built_work_places do
    get 'view', :on => :member
  end
  resources :dams_iconographies do
    get 'view', :on => :member
  end
  resources :dams_techniques do
    get 'view', :on => :member
  end
  resources :dams_cultural_contexts do
    get 'view', :on => :member
  end
  resources :dams_functions do
    get 'view', :on => :member
  end
  resources :mads_personal_names do
    get 'view', :on => :member
  end
  resources :mads_family_names do
    get 'view', :on => :member
  end
  resources :mads_corporate_names do
    get 'view', :on => :member
  end
  resources :mads_conference_names do
    get 'view', :on => :member
  end
  resources :mads_complex_subjects do
    get 'view', :on => :member
  end
  resources :mads_topics do
    get 'view', :on => :member
  end
  resources :mads_temporals do
    get 'view', :on => :member
  end
  resources :mads_names do
    get 'view', :on => :member
  end
  resources :mads_occupations do
    get 'view', :on => :member
  end
  resources :mads_genre_forms do
    get 'view', :on => :member
  end
  resources :mads_geographics do
    get 'view', :on => :member
  end
  resources :mads_schemes do
    get 'view', :on => :member
  end
  resources :mads_authority, :as => 'mads_authorities' do
    get 'view', :on => :member
  end
  resources :mads_languages do
    get 'view', :on => :member
  end

  resources :get_data do
	get 'get_linked_data', :on => :member
	post 'get_linked_data', :on => :member
	get 'get_name', :on => :member
	post 'get_name', :on => :member	
	get 'get_subject', :on => :member
	post 'get_subject', :on => :member		
  end
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
