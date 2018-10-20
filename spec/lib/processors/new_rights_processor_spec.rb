require 'spec_helper'

describe Processors::NewRightsProcessor do
  let!(:response) { {email: 'test@example.com'} }
  let!(:bad_response) { {email: 'invalid_email_format'} }
  let!(:obj) { Processors::NewRightsProcessor.new(response) }
  let!(:bad_obj) { Processors::NewRightsProcessor.new(bad_response) }

  describe "initialize" do
    it "if received valid request_attributes" do
      expect(obj).to be_instance_of(Processors::NewRightsProcessor)
    end
  end

  describe "process" do
    it "runs successfully with valid attributes" do
      expect { obj.process }.to_not raise_error
    end

    it "fails with invalid attributes" do
      expect { bad_obj.process }.to change { User.count }.by(0)
    end

    it "sends email to user on success" do
      expect { obj.process }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
