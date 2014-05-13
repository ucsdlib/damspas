require "spec_helper"

describe AuditsController do
  describe "routing" do

    it "routes to #index" do
      get("/audits").should route_to("audits#index")
    end

    it "routes to #show" do
      get("/audits/1").should route_to("audits#show", :id => "1")
    end

  end
end
