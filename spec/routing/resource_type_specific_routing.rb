require 'spec_helper'

describe 'resources should be routed to resource-type specific paths' do
  include Rails.application.routes.url_helpers

  it "should route SolrDocuments for DamsObjects correctly" do
  	doc = SolrDocument.new(:id => 'zzz', :has_model_ssim => ['info:fedora/afmodel:DamsObject'], :object_profile_ssm => '{"datastreams": {} }')

    {:get => polymorphic_path(doc)}.
      should route_to(:controller => "dams_objects", :action => "show", :id => 'zzz')
  end	

end