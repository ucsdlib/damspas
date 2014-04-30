require 'spec_helper'

describe "Audits" do
  describe "GET /audits" do
    it "should list audits" do
      get audits_path
      response.status.should be(200)
    end
  end
  describe "GET /audits/:id" do
    it "should show audits" do
      @audit = Audit.create(description:"test", user: "foo@bar.com", object: "xx1234567x")
      get audit_path @audit
      response.status.should be(200)
    end
  end
end
