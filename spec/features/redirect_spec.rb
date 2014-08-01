require 'spec_helper'

feature "Viewing a record in the wrong controller should redirect" do
  scenario "An object should redirect to the object controller" do
    obj_ark = 'bd3379993m'
    visit dams_collection_path(obj_ark)
    current_path.should == dams_object_path(obj_ark)
  end
  scenario "A collection should redirect to the collection controller" do
    col_ark = 'bb24242424'
    visit dams_object_path(col_ark)
    current_path.should == dams_collection_path(col_ark)
  end
end
