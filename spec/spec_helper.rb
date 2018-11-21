require 'coveralls'
Coveralls.wear!('rails')

require 'rspec/matchers'
require 'equivalent-xml'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Devise helper
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
#  config.order = "random"
  config.before(:suite) do
    cleanout_solr_and_fedora
  end
  config.after(:suite) do
    cleanout_solr_and_fedora
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
# This loads the Fedora and Solr config info from /config/fedora.yml
# You can load it from a different location by passing a file path as an argument.
def restore_spec_configuration
  ActiveFedora.init(fedora_config_path: File.join(File.dirname(__FILE__), "..", "config", "fedora.yml"))
end

def cleanout_solr_and_fedora
  ActiveFedora::Base.destroy_all
  restore_spec_configuration if ActiveFedora::SolrService.instance.nil? || ActiveFedora::SolrService.instance.conn.nil?
  ActiveFedora::SolrService.instance.conn.delete_by_query('*:*', params: {'softCommit' => true})
end
def test_attribute_xpath(datastream, name, xpath, value='blah')
   datastream.send(name.to_s+'=', value)
   expect(datastream.send(name)).to eq([value])
   expect(datastream.send(name).xpath).to eq(xpath)
end
def test_existing_attribute(datastream, name, value='blah')
   expect(datastream.send(name)).to eq([value])
end

def solr_index (pid)
  # index the record
  begin
    solrizer = Solrizer::Fedora::Solrizer.new
    solrizer.solrize pid
  rescue Exception => e
    logger.warn "Error indexing #{pid}: #{e}"
  end
end

def find_solr_records(q, params={})
  solr_docs = ActiveFedora::SolrService.query(q, params)
  solr_docs.map { |doc| doc["id"] }
end

def create_test_dams_object id='test_pid', title='test_title'
  DamsObject.create!(pid: id, titleValue: title)
end

def mod_dams_object (id, unit, copy)
	DamsObject.create!(pid: id, titleValue: "Test Title -- Unit #{unit}", unitURI: unit, copyrightURI: copy)
end
def mod_dams_provenance_collection (id, unit)
	DamsProvenanceCollection.create!(pid: id, titleValue: "Test ProvenanceCollection Title -- Unit #{unit}", unitURI: unit, visibility: "curator", resource_type: "text")
end
def mod_dams_provenance_collection_part (id, unit)
	DamsProvenanceCollectionPart.create!(pid: id, titleValue: "Test ProvenanceCollectionPart Title -- Unit #{unit}", unitURI: unit, visibility: "curator", resource_type: "text")
end
def mod_dams_assembled_collection (id, unit)
	DamsAssembledCollection.create!(pid: id, titleValue: "Test AssembledCollection Title -- Unit #{unit}", unitURI: unit, visibility: "curator", resource_type: "text")
end
def mod_dams_unit (id)
	DamsUnit.create!(pid: id, name: "Test Unit Program", description: "A Unit for test.", uri: "http://test.ucsd.edu/", code: "test")
end
def mod_dams_copyright (id)
	DamsCopyright.create!(pid: id,status: "Under copyright test", jurisdiction: "us", purposeNote: "Test purpose note.", note: "Test note.", beginDate: "2013-12-31")
end
def mod_mads_name (id)
	MadsName.create!(pid: id, name: "Mads Name Test ", externalAuthority: "http://lccn.loc.gov/n90694888")
end
def mod_mads_personal_name (id)
	MadsPersonalName.create!(pid: id,name: "Mads Personal Name Test ", externalAuthority: "http://lccn.loc.gov/n90694888")
end

def mod_mads_topic (id)
	MadsTopic.create!(pid: id, name: "Mads Topic Test Label", externalAuthority: "http://lccn.loc.gov/")
end


