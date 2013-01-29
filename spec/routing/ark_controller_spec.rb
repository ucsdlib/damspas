require 'spec_helper'

describe "ARK-based permalinks" do
  it "should route to the catalog page" do
    { :get => "/ark:/20775/bXXXXXXX2" }.
  should route_to(
    :controller => "catalog",
    :action => "show",
    :id => "bXXXXXXX2",
    :ark => 'ark:' # it'd be nice not to have this, but whatever.
  )
  end
end