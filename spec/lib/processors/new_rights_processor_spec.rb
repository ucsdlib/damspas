require 'spec_helper'

describe Processors::NewRightsProcessor do
  let!(:options){ [[{email: "test@example.com"}, {email: "invalid_email_format"}, {email: ""}], [{work_pid: "test_pid"}, {work_pid: 'bad_pid'}]] }
  let!(:obj){ Processors::NewRightsProcessor.new(response) }

  describe "initialize" do
    context "if rake task is run with valid credentials" do
      let!(:response){ select_response_options(0,0) } # arguments correspond to positions of values in the options array (email and work_title arrays, respectively)
      it "runs successfully" do
        expect(obj).to be_instance_of(Processors::NewRightsProcessor)
      end
    end

    context "if rake task is run with invalid credentials" do
      let!(:response){ select_response_options(1,1) }
      it "fails quietly" do
        expect{ obj.process }.to_not raise_error
      end
    end
  end

  describe "process" do
    context "when credentials are valid" do
      let!(:response){ select_response_options(0,0) }
      it "runs successfully" do
        expect{ obj.process }.to_not raise_error
      end

      it "sets user attributes correctly" do
        obj.process # @user is not set in module until process method is run
        user = obj.instance_variable_get(:@user)

        expect(user.provider).to eq('auth_link')
        expect(user.uid).to_not be_empty
        expect(user.authentication_token).to_not be_empty
      end

      it "does not alter the attributes of an existing user" do
        before_rake_user = create_auth_link_user # creates user w/ same email as option {0}
        obj.process
        after_rake_user = obj.instance_variable_get(:@user)

        expect(after_rake_user.id).to eq(before_rake_user.id)
        expect(after_rake_user.email).to eq(before_rake_user.email)
        expect(after_rake_user.uid).to eq(before_rake_user.uid)
        expect(after_rake_user.provider).to eq(before_rake_user.provider)
      end

      it "authorizes the work for the user" do
        create_test_dams_object
        obj.process
        user = obj.instance_variable_get(:@user)

        expect(user.work_authorizations.count).to eq(1)
      end

      it "sends email to user on success" do
        create_test_dams_object
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when email has an invalid format" do
      let!(:response){ select_response_options(1,0) }
      it "fails with invalid attributes" do
        expect{ obj.process }.to change{ User.count }.by(0)
      end

      it "does not send email on failure" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when email is blank" do
      let!(:response){ select_response_options(2,0) }
      it "validates the presence of an email" do
        User.where(email: '').first_or_create! # protect against if a user w/ a blank email already exists in db

        expect{ obj.process }.to_not raise_error
        expect{ obj.process }.to change{ User.count }.by(0)
      end

      it "does not send an email" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when work title is missing" do
      let!(:response){ select_response_options(0,1) }
      it "fails quietly" do
        expect{ obj.process }.to_not raise_error
      end

      it "does not assign a work to a user" do
        obj.process
        user = obj.instance_variable_get(:@user)

        expect(user.work_authorizations.count).to eq(0)
      end

      it "does not send an email" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
