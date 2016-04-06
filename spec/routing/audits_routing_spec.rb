require "spec_helper"

describe AuditsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/audits")).to route_to("audits#index")
    end

    it "routes to #show" do
      expect(get("/audits/1")).to route_to("audits#show", :id => "1")
    end

  end
end
