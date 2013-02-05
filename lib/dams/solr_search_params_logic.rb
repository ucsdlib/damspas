module Dams
  module SolrSearchParamsLogic
    def scope_search_to_unit solr_parameters, user_parameters
      unit = DamsUnit.find(user_parameters[:unit]) rescue nil

      if unit
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << fq_for_unit(unit)
      end
    end

    private
    def fq_for_unit unit
      facet_value_to_fq_string(blacklight_config.unit_id_solr_field, unit.id)
    end
  end
end
