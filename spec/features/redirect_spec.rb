require 'spec_helper'

feature "Viewing a record in the wrong controller should redirect" do
  before do
    @copy = DamsCopyright.create status: "public domain"
    @obj = DamsObject.create titleValue: "Test Object", copyrightURI: @copy.pid
    @col = DamsAssembledCollection.create titleValue: "Test Collection", visibility: "public"
    solr_index @obj.pid
    solr_index @col.pid
  end
  after do
    @obj.delete
    @col.delete
    @copy.delete
  end
  scenario "An object should redirect to the object controller" do
    visit dams_collection_path(@obj.pid)
    current_path.should == dams_object_path(@obj.pid)
  end
  scenario "A collection should redirect to the collection controller" do
    visit dams_object_path(@col.pid)
    current_path.should == dams_collection_path(@col.pid)
  end
end
