require "spec_helper"

describe AuditsController do
  describe "routing" do

    it "routes to #index" do
      get("/audits").should route_to("audits#index")
    end

    it "routes to #new" do
      get("/audits/new").should route_to("audits#new")
    end

    it "routes to #show" do
      get("/audits/1").should route_to("audits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/audits/1/edit").should route_to("audits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/audits").should route_to("audits#create")
    end

    it "routes to #update" do
      put("/audits/1").should route_to("audits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/audits/1").should route_to("audits#destroy", :id => "1")
    end

  end
end
