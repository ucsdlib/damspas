# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include Blacklight::Catalog
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  include Hydra::Controller::ControllerBehavior

  # support boolean operators, even in basic search
  include BlacklightAdvancedSearch::ParseBasicQ

  ##
  # Search requests that include a 'unit' parameter will have their
  # search scoped to just that unit.
  include Dams::SolrSearchParamsLogic
  CatalogController.solr_search_params_logic += [:scope_search_to_unit]

  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
#  CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]

  # exclude opentopo records here
  CatalogController.solr_search_params_logic += [:exclude_opentopo]
  def exclude_opentopo(solr_parameters,user_parameters)
    solr_parameters[:fq] << "-collections_tesim:#{Rails.configuration.excluded_collections}"
    solr_parameters[:fq] << "(has_model_ssim:\"info:fedora/afmodel:DamsObject\" OR has_model_ssim:\"info:fedora/afmodel:DamsUnit\" OR type_tesim:Collection)"
  end

  configure_blacklight do |config|
	
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10,
      :qf => 'subject_tesim title_tesim date_tesim name_tesim id component_title_tesim',
    }
	
	#UCSD custom added argument config.highlighting to turn on/off hit highlighting with config.highlighting=true|false
	#config.hlTagPre for custom highlighting fragment prefix tag
	#config.hlTagPost for custom highlighting fragment post tag
	#config.hlMaxFragsize override fragment size for a field
	config.highlighting = true;
	config.hlTagPre = '<span class=\'search-highlight\'>'
	config.hlTagPost = '</span>'
	config.hlMaxFragsize = 150
	if config.highlighting
	  config.default_solr_params['hl.fragsize'] = 0
	  config.default_solr_params['hl.snippets'] = 100
	  config.default_solr_params['hl.fragListBuilder'] = 'single'
	  config.default_solr_params['hl.boundaryScanner'] = 'simple'
	  config.default_solr_params['hl.simple.pre'] = config.hlTagPre
	  config.default_solr_params['hl.simple.post'] = config.hlTagPost
	  config.default_solr_params['f.note_tesim.hl.fragsize'] = config.hlMaxFragsize
	  config.default_solr_params['hl.fl'] = 'title_json_tesim name_json_tesim subject_json_tesim date_json_tesim unit_name_tesim collection_1_name_tesim id name_tesim subject_tesim date_tesim note_tesim' 
	end

    # solr field configuration for search results/index views
    config.index.show_link = 'title_json_tesim'
    config.index.record_display_type = 'has_model_sim'

    # solr field configuration for document/show views
    config.show.html_title = 'title_tesim'
    config.show.heading = 'title_tesim'
    config.show.display_type = 'has_model_sim'


    config.unit_id_solr_field = 'unit_id_tesim'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar
    config.add_facet_field 'object_type_sim', :label => 'Format' 
    config.add_facet_field 'subject_topic_sim', :label => 'Topic', :limit => 20 
    config.add_facet_field 'collection_sim', :label => 'Collection', :limit => 20
    config.add_facet_field 'unit_sim', :label => 'Unit'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
	#	UCSD custom added argument :hitsonly to display the values that has hit text.
    config.add_index_field 'name_tesim', :label => 'Name:', :highlight => config.highlighting   
    config.add_index_field 'date_tesim', :label => 'Date:', :highlight => config.highlighting
    config.add_index_field 'unit_name_tesim', :label => 'Unit:', :highlight => config.highlighting
    config.add_index_field 'collection_1_name_tesim', :label => 'Collection:', :highlight => config.highlighting
    config.add_index_field 'subject_tesim', :label => 'Subject:', :highlight => config.highlighting
	config.add_index_field 'note_tesim', :label => 'Note:', :highlight => config.highlighting, :hitsonly => true   
    #config.add_index_field 'description_tesim', :label => 'Description:' 
	
	#config.add_field_configuration_to_solr_request!  

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
    #config.add_show_field 'date_tesim', :label => 'Date:'
    #config.add_show_field 'subject_tesim', :label => 'Subject:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    config.add_search_field ('Keyword (Title, Name/Creator, Topic, Notes etc.)') do |field|
	  #field.solr_parameters = { :'qf' => 'all_fields_tesim' }
	  field.solr_parameters = { :'qf' => 'subject_tesim title_tesim date_tesim name_tesim id component_title_tesim' }
	end 
    config.add_search_field('Title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params. 
      field.solr_parameters = { :'spellcheck.dictionary' => 'title_tesim' }
	  field.solr_parameters = { :'qf' => 'title_tesim' }
      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      #field.solr_local_parameters = { 
      #  :qf => '$title_qf',
      #  :pf => '$title_pf'
      #}
    end
    config.add_search_field ('Name/Creator') do |field|
	  field.solr_parameters = { :'qf' => 'name_tesim' }
	end
    config.add_search_field('subject', :label => 'Topic') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject_tesim' }
	  field.solr_parameters = { :'qf' => 'subject_tesim' }
      #field.qt = 'search'
      #field.solr_local_parameters = { 
      #  :qf => '$subject_qf',
      #  :pf => '$subject_pf'
      #}
    end
    config.add_search_field ('Notes') do |field|
	  field.solr_parameters = { :'qf' => 'note_tesim' }
	end
    config.add_search_field ('Fulltext') do |field|
	  field.solr_parameters = { :'qf' => 'fulltext_tesim' }
	end

    #config.add_search_field('author') do |field|
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
    #  field.solr_local_parameters = { 
    #    :qf => '$author_qf',
    #    :pf => '$author_pf'
    #  }
    #end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, system_create_dtsi desc, title_ssi asc', :label => "relevance \u25BC"
    #config.add_sort_field 'pub_date_ssi desc, title_ssi asc', :label => 'year'
    config.add_sort_field 'system_create_dtsi desc', :label => "date uploaded \u25BC"
    config.add_sort_field 'system_create_dtsi asc', :label => "date uploaded \u25B2"
    config.add_sort_field 'system_modified_dtsi desc', :label => "date modified \u25BC"
    config.add_sort_field 'system_modified_dtsi asc', :label => "date modified \u25B2"
    #config.add_sort_field 'author_ssi asc, title_ssi asc', :label => 'author'
    config.add_sort_field 'title_ssi asc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end
      # get search results from the solr index
    def index
      
      extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => t('blacklight.search.rss_feed') )
      extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => t('blacklight.search.atom_feed') )
      
      (@response, @document_list) = get_search_results
	  if(@document_list.size == 0)
		if(params['spellcheck.q'].nil?)
			params['spellcheck.q'] = params[:q]
		else
			params.delete('spellcheck.q')
		end
		
		i = 0
		@suggestions = ([@response.spelling.collation] | @response.spelling.words).compact
		@suggestions.each do |word|
			i = i + 1
			params[:q] = word
			(@response, @document_list) = get_search_results params
			if(@document_list.size > 0)
				#if(params['spellcheck.q'].nil?)
				j = 0
				@suggestions.each do |word|
					j = j + 1
					#Exclude those that have no results
					if j > i
						@response.spelling.words << word unless word.nil?
					end
				end
				#end
				break;
			end
		end
	  else
		params['spellcheck.q'] = params[:q]
		@response.spelling.words << @response.spelling.collation unless @response.spelling.collation.nil?
	  end
	  @response.spelling.words.uniq
      @filters = params[:f] || []
      
      respond_to do |format|
        format.html { save_current_search_params }
        format.rss  { render :layout => false }
        format.atom { render :layout => false }
      end
    end
end 
