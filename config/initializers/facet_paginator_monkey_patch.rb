# frozen_string_literal: true

Blacklight::Solr::FacetPaginator.class_eval do
  @request_keys = { sort: :'facet.sort', page: :'page' }

  attr_reader :total_pages_count

  def total_pages
    @total_pages_count
  end

  def pages_count(count)
    @total_pages_count = count
  end

  def limit_value
    @limit
  end
end
