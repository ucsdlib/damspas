require 'spec_helper'

RSpec.describe WorkAuthorization, type: :model do
  describe "adding errors" do
    let(:authorization){ WorkAuthorization.new  }
    it "should add the error" do
      authorization.update_error "test error"
      expect(authorization.error).to eq("test error")
    end

    it "should clear error" do
      authorization.update_error "test error"
      authorization.clear_error
      expect(authorization.error).to eq(nil)
    end
  end
end
