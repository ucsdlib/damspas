Hydra::Application.routes.draw do


  resources :pages
  get '/p/:id', to: 'pages#view', :as => 'view_page'

  # Static page routes
  get '/faq', to: 'static_pages#faq'
  get '/about', to: 'static_pages#about'
  get '/zotero', to: 'static_pages#zotero'
  get '/mendeley', to: 'static_pages#mendeley'
  get '/takedown', to: 'static_pages#takedown'
  get '/search_tips', to: 'static_pages#search_tips'

  # Contact form routes
  resources :contact_form, :only => [:new, :create]
  post 'contact' => 'contact_form#create'
  get 'contact' => 'contact_form#new'

  #resources :units, :only => [:index, :show]
  root :to => "dams_units#index"
  resources :collection, :only => [:show], :controller => 'dams_collections', :as => 'dams_collections'
  get '/dlp', to: 'dams_units#show', :id => 'dlp'
  get '/rci', to: 'dams_units#show', :id => 'rci'
  get '/:id/collections', to: 'catalog#collection_search', :as => "dams_unit_collections"
  get '/solrdoc/:id', to: 'catalog#solrdoc', :as => "solrdoc"
  get "collections", :to => 'catalog#collection_search', :as => 'dams_collections'

  Blacklight.add_routes(self, :except => [:solr_document, :catalog]  )

  # add Blacklight catalog -> search routing
  # Catalog stuff.
  get 'search/opensearch', :as => "opensearch_catalog"
  get 'search/citation', :as => "citation_catalog"
  get 'search/email', :as => "email_catalog"
  get 'search/sms', :as => "sms_catalog"
  get 'search/endnote', :as => "endnote_catalog"
  get 'search/send_email_record', :as => "send_email_record_catalog"
  get "search/facet/:id", :to => 'catalog#facet', :as => 'catalog_facet'
  get "search", :to => 'catalog#index', :as => 'catalog_index'
  get 'search/:id/librarian_view', :to => "catalog#librarian_view", :as => "librarian_view_catalog"
  resources :solr_document, :path => 'search', :controller => 'catalog', :only => [:show, :update]
  # :show and :update are for backwards-compatibility with catalog_url named routes
  resources :catalog, :only => [:show, :update]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/users/sign_in', :to => "users/sessions#new", :as => :new_user_session
    get '/users/sign_out', :to => "users/sessions#destroy", :as => :destroy_user_session
  end

  resources :dams_subjects, :only => [:show]

  resources :object, :controller => 'dams_objects', :as => 'dams_objects'

  post "object/:id/upload", :to => 'file#create', :as => 'upload'
  post "object/:id/deriv/:ds", :to => 'file#deriv', :as => 'deriv'
  get "object/:id/zoom/:cmp", :to => 'dams_objects#zoom', :as => 'zoom'
  get "object/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
  resources :dams_assembled_collections
  resources :dams_units do
    member do
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
  resources :dams_built_work_places
  resources :dams_iconographies
  resources :dams_style_periods
  resources :dams_scientific_names
  resources :dams_techniques
  resources :dams_cultures
  resources :dams_cultural_contexts
  resources :dams_functions
  resources :mads_personal_names
  resources :mads_family_names
  resources :mads_corporate_names
  resources :mads_conference_names
  resources :mads_complex_subjects
  resources :mads_topics
  resources :mads_temporals
  resources :mads_names
  resources :mads_occupations
  resources :mads_genre_forms
  resources :mads_geographics
  resources :mads_schemes
  resources :mads_authority, :as => 'mads_authorities'
  resources :mads_languages

  resources :get_data do
	get 'get_linked_data', :on => :member
	post 'get_linked_data', :on => :member
	get 'get_name', :on => :member
	post 'get_name', :on => :member	
	get 'get_subject', :on => :member
	post 'get_subject', :on => :member
	get 'get_ark', :on => :member		
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   get 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
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
  # get ':controller(/:action(/:id))(.:format)'
end
