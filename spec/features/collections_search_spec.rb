require 'spec_helper'

feature 'Visitor wants to browse by unit collections' do
  describe 'RDCP browse by collection page' do
    before do
      @unit = DamsUnit.create(pid: 'xx48484848', name: "Research Data Curation Program", description: "Research data", code: "rdcp", uri: "http://library.ucsd.edu/rdcp")
      @oldest_collection = DamsProvenanceCollection.create(pid: 'collection_1', titleValue: "A Old Collection", unitURI: @unit.pid, visibility: "public", resource_type: "text")
      @oldest_collection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
      solr_index @unit.pid
      solr_index @oldest_collection.pid

      # manipulate ActiveFedora::Base#create_date to create a "newer" collection record
      allow_any_instance_of(DamsProvenanceCollection).to receive(:create_date).and_return(Time.now + 1.week)
      @newest_collection = DamsProvenanceCollection.create(pid:'collection_2', titleValue: "The New Collection", unitURI: @unit.pid, visibility: "public", resource_type: "text")
      @newest_collection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
      solr_index @newest_collection.pid
    end
    after do
      @unit.delete
      @oldest_collection.delete
      @newest_collection.delete
    end
    it 'should sort by most recent collection by default, descending to oldest' do
      visit dams_unit_collections_path('rdcp')
      old_collection_sort_order = page.body.index('A Old Collection')
      new_collection_sort_order = page.body.index('The New Collection')
      expect(old_collection_sort_order).to be > new_collection_sort_order
    end

    it 'should still allow user selected sort options' do
      visit dams_unit_collections_path('rdcp', { sort: 'title_ssi asc' })
      old_collection_sort_order = page.body.index('A Old Collection')
      new_collection_sort_order = page.body.index('The New Collection')
      expect(old_collection_sort_order).to be < new_collection_sort_order
    end
  end

  describe 'DLDP browse by collection page' do
    before do
      @unit = DamsUnit.create(pid: 'xx48484848', name: "DLDP", description: "DLDP", code: "dldp", uri: "http://library.ucsd.edu/dldp")
      @oldest_collection = DamsProvenanceCollection.create(pid: 'collection_1', titleValue: "A Old Collection", unitURI: @unit.pid, visibility: "public", resource_type: "text")
      @oldest_collection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
      solr_index @unit.pid
      solr_index @oldest_collection.pid

      Timecop.freeze(Date.today + 5) do
        @newest_collection = DamsProvenanceCollection.create(pid:'collection_2', titleValue: "The New Collection", unitURI: @unit.pid, visibility: "public", resource_type: "text")
        @newest_collection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection3.rdf.xml').read
        solr_index @newest_collection.pid
      end
    end
    after do
      @unit.delete
      @oldest_collection.delete
      @newest_collection.delete
    end
    it 'should sort by collection title, ascending' do
      visit dams_unit_collections_path('dldp')
      old_collection_sort_order = page.body.index('A Old Collection')
      new_collection_sort_order = page.body.index('The New Collection')
      expect(old_collection_sort_order).to be < new_collection_sort_order
    end
  end
end
