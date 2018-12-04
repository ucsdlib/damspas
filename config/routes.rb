Hydra::Application.routes.draw do
  namespace :aeon do
    resources :queues do
      collection do
        get 'errors'
      end
    end
    resources :requests do
      member do
        get 'set_to_new'
        get 'set_to_active'
        get 'set_to_complete'
        get 'set_to_expire'
      end
    end
  end
  get 'work_authorizations', to: 'work_authorizations#index', :as => 'work_authorizations' do
  end
  resources :audits, :only => [:index, :show]
  resources :pages
  get '/p/:id', to: 'pages#view', :as => 'view_page'

  # Contact form routes
  resources :contact_forms, :only => [:new, :response]
  get 'contact' => 'contact_forms#new'
  get 'contact_response' => 'contact_forms#response'

  mount Qa::Engine => '/qa'

  #resources :units, :only => [:index, :show]
  root :to => "dams_units#index"
  resources :collection, :only => [:show], :controller => 'dams_collections', :as => 'dams_collections' do
    member do
      get 'dams42'
      get 'data'
      get 'ezid'
      get 'rdf'
      get 'rdf_nt'
      get 'rdf_ttl'
      get 'osf_api'
      get 'osf_push'
      get 'osf_delete'
      get 'osf_data'
    end
  end

  get '/dlp', to: 'dams_units#show', :id => 'dlp'
  get '/rdcp', to: 'dams_units#show', :id => 'rdcp'
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
    get '/users/auth_link', :to => "users/sessions#new_auth_link", :as => :new_auth_link
    post '/users/auth_link/create', :to => "users/sessions#create_auth_link", :as => :create_auth_link
  end

  resources :dams_subjects, :only => [:show]

  resources :object, :controller => 'dams_objects', :as => 'dams_objects', only: [:index, :show] do
    member do
      get 'dams42'
      get 'data'
      get 'ezid'
      get 'rdf'
      get 'rdf_nt'
      get 'rdf_ttl'
    end
  end

  #post "object/:id/upload", :to => 'file#create', :as => 'upload'
  post "object/:id/deriv/:ds", :to => 'file#deriv', :as => 'deriv'
  get "object/:id/zoom/:cmp", :to => 'dams_objects#zoom', :as => 'zoom'

  # EMBED UI
  get "embed/:id/:cmp", :to => 'dams_objects#embed', :as => 'embed'
  # EMBED UI END

  get "object/:id/edit", :to => 'dams_objects#edit', :as => 'edit'
  put "object/:id", :to => 'dams_objects#update', :as => 'update'
  get "object/:id/:ds", :to => 'file#show', :constraints => { :ds => /[^\/]+/ }, :as => 'file'
  get "object/:id/:ds/download", :to => 'file#show', defaults: { disposition: 'attachment' }, :constraints => { :ds => /[^\/]+/ }, :as => 'download'
  resources :dams_assembled_collections, only: [:index, :show]
  resources :dams_units, only: [:index, :show] do
    member do
      get 'collections'
    end
  end
  resources :dams_copyrights, only: [:index, :show]
  resources :dams_licenses, only: [:index, :show]
  resources :dams_other_rights, only: [:index, :show]
  resources :dams_statutes, only: [:index, :show]
  resources :dams_languages, only: [:index, :show]
  resources :dams_vocabularies, only: [:index, :show]
  resources :dams_roles, only: [:index, :show]
  resources :dams_provenance_collections, only: [:index, :show]
  resources :dams_provenance_collection_parts, only: [:index, :show]
  resources :dams_vocabulary_entries, only: [:index, :show]
  resources :dams_source_captures, only: [:index, :show]
  resources :dams_cartographics, only: [:index, :show]
  resources :dams_built_work_places, only: [:index, :show]
  resources :dams_iconographies, only: [:index, :show]
  resources :dams_style_periods, only: [:index, :show]
  resources :dams_scientific_names, only: [:index, :show]
  resources :dams_techniques, only: [:index, :show]
  resources :dams_cultures, only: [:index, :show]
  resources :dams_cultural_contexts, only: [:index, :show]
  resources :dams_functions, only: [:index, :show]
  resources :dams_related_resources, only: [:index, :show]
  resources :mads_personal_names, only: [:index, :show]
  resources :mads_family_names, only: [:index, :show]
  resources :mads_corporate_names, only: [:index, :show]
  resources :mads_conference_names, only: [:index, :show]
  resources :mads_complex_subjects, only: [:index, :show]
  resources :mads_topics, only: [:index, :show]
  resources :mads_temporals, only: [:index, :show]
  resources :mads_names, only: [:index, :show]
  resources :mads_occupations, only: [:index, :show]
  resources :mads_genre_forms, only: [:index, :show]
  resources :mads_geographics, only: [:index, :show]
  resources :mads_schemes, only: [:index, :show]
  resources :mads_authority, :as => 'mads_authorities', only: [:index, :show]
  resources :mads_languages, only: [:index, :show]
  resources :dams_lithologies, only: [:index, :show]
  resources :dams_series, only: [:index, :show]
  resources :dams_cruises, only: [:index, :show]
  resources :dams_anatomies, only: [:index, :show]

  resources :get_data do
  get 'get_linked_data', :on => :member
  post 'get_linked_data', :on => :member
  get 'get_name', :on => :member
  post 'get_name', :on => :member
  get 'get_subject', :on => :member
  post 'get_subject', :on => :member
  get 'get_creator', :on => :member
  post 'get_creator', :on => :member
  get 'get_ark', :on => :member
  get 'get_new_objects'
  get 'get_dams_data', :on => :member
  post 'get_dams_data', :on => :member

  end

  resources :random

  # ruby-version utility
  get '/ruby-version' => 'application#ruby_version'

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
