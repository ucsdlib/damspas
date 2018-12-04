require 'spec_helper'

describe Processors::NewRightsProcessor do

  # calling Hashie::Mash.new allows us to use the
  # .id method from the Aeon::Request model
  let(:good_email){ Hashie::Mash.new({email: 'test@example.com'}) }
  let(:bad_email){ Hashie::Mash.new({email: 'invalid_email_format'}) }
  let(:no_email){ Hashie::Mash.new({email: ''}) }
  let(:good_pid){ Hashie::Mash.new({subLocation: 'test_pid'}) }
  let(:bad_pid){ Hashie::Mash.new({subLocation: 'bad_pid'}) }
  let(:nil_pid){ Hashie::Mash.new({subLocation: nil}) }

  before do
    allow_any_instance_of(Aeon::Request).to receive(:set_to_active).and_return(true)
    allow_any_instance_of(Aeon::Request).to receive(:set_to_processing).and_return(true)
  end

  describe "initialize" do
    context "if rake task is run with valid credentials" do
      let!(:response){ good_email.merge(good_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "runs successfully" do
        expect(processor).to be_instance_of(Processors::NewRightsProcessor)
      end
    end

    context "if rake task is run with invalid credentials" do
      let!(:response){ bad_email.merge(bad_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "fails quietly" do
        expect{ processor.authorize }.to_not raise_error
      end
    end
  end

  describe "authorize" do
    let!(:dams_object){ DamsObject.create(pid: 'test_pid', titleValue: 'test_title') }
    context "when credentials are valid" do
      let!(:user){ create_auth_link_user } # creates user w/ same email as response 
      let!(:response){ good_email.merge(good_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "runs successfully" do
        expect{ (allow(processor).to receive(:authorize).and_return(true)) }.to_not raise_error
      end

      it "sets user attributes correctly" do
        processor.authorize
        user.reload
        expect(user.provider).to eq('auth_link')
        expect(user.uid).to_not be_empty
        expect(user.authentication_token).to_not be_empty
      end

      it "does not alter the attributes of an existing user" do
        user.reload
        expect{processor.authorize}.to_not change{user.id}
        expect{processor.authorize}.to_not change{user.email}
        expect{processor.authorize}.to_not change{user.uid}
        expect{processor.authorize}.to_not change{user.provider}
      end

      it "authorizes the work for the user" do
        expect{ processor.authorize }.to change{ user.reload and user.work_authorizations.length }.from(0).to(1)
      end

      it "sends email to user on success" do
        expect{ processor.authorize }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when email has an invalid format" do
      let!(:response){ bad_email.merge(good_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "fails with invalid attributes" do
        expect{ processor.authorize }.to change{ User.count }.by(0)
      end

      it "does not send email on failure" do
        expect{ processor.authorize }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when email is blank" do
      let!(:response){ no_email.merge(good_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "validates the presence of an email" do
        User.where(email: '').first_or_create! # protect against if a user w/ a blank email already exists in db

        expect{ processor.authorize }.to_not raise_error
        expect{ processor.authorize }.to change{ User.count }.by(0)
      end

      it "does not send an email" do
        expect{ processor.authorize }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when requested work doesn't exist" do
      let!(:response){ good_email.merge(bad_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "fails quietly" do
        expect{ processor.authorize }.to_not raise_error
      end

      it "does not assign a work to a user" do
        expect{ processor.authorize }.to change{ WorkAuthorization.all.length }.by(0)
      end

      it "does not send an email" do
        expect{ processor.authorize }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when work pid is nil" do
      let!(:response){ good_email.merge(nil_pid) }
      let!(:processor){ Processors::NewRightsProcessor.new(response) }
      it "fails quietly" do
        expect{ processor.authorize }.to_not raise_error
      end

      it "does not assign a work to a user" do
        expect{ processor.authorize }.to change{ WorkAuthorization.all.length }.by(0)
      end

      it "does not send an email" do
        expect{ processor.authorize }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end

