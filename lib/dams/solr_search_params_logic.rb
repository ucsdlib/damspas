module Dams
  module SolrSearchParamsLogic
    def scope_search_to_repository solr_parameters, user_parameters
      repository = DamsRepository.find(user_parameters[:repository]) rescue nil

      if repository
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << facet_value_to_fq_string('repository_id_s', repository.id)
      end
    end
  end
end