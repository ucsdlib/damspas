require 'spec_helper'

describe Processors::NewRightsProcessor do
  let!(:obj){ Processors::NewRightsProcessor.new(response) }

  let(:good_email){ {email: 'test@example.com'} }
  let(:bad_email){ {email: 'invalid_email_format'} }
  let(:no_email){ {email: ''} }

  let(:good_pid){ {work_pid: 'test_pid'} }
  let(:bad_pid){ {work_pid: 'bad_pid'} }
  let(:nil_pid){ {work_pid: nil} }



  describe "initialize" do
    context "if rake task is run with valid credentials" do
      let!(:response){ good_email.merge(good_pid) }
      it "runs successfully" do
        expect(obj).to be_instance_of(Processors::NewRightsProcessor)
      end
    end

    context "if rake task is run with invalid credentials" do
      let!(:response){ bad_email.merge(bad_pid) }
      it "fails quietly" do
        expect{ obj.process }.to_not raise_error
      end
    end
  end

  describe "process" do
    let!(:dams_object){ DamsObject.create(pid: 'test_pid', titleValue: 'test_title') }

    context "when credentials are valid" do
      let!(:response){ good_email.merge(good_pid) }
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
        obj.process
        user = obj.instance_variable_get(:@user)

        expect(user.work_authorizations.length).to eq(1)
      end

      it "sends email to user on success" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when email has an invalid format" do
      let!(:response){ bad_email.merge(good_pid) }
      it "fails with invalid attributes" do
        expect{ obj.process }.to change{ User.count }.by(0)
      end

      it "does not send email on failure" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when email is blank" do
      let!(:response){ no_email.merge(good_pid) }
      it "validates the presence of an email" do
        User.where(email: '').first_or_create! # protect against if a user w/ a blank email already exists in db

        expect{ obj.process }.to_not raise_error
        expect{ obj.process }.to change{ User.count }.by(0)
      end

      it "does not send an email" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when requested work doesn't exist" do
      let!(:response){ good_email.merge(bad_pid) }
      it "fails quietly" do
        expect{ obj.process }.to_not raise_error
      end

      it "does not assign a work to a user" do
        expect{ obj.process }.to change{ WorkAuthorization.all.length }.by(0)
      end

      it "does not send an email" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end

    context "when work pid is nil" do
      let!(:response){ good_email.merge(nil_pid) }
      it "fails quietly" do
        expect{ obj.process }.to_not raise_error
      end

      it "does not assign a work to a user" do
        expect{ obj.process }.to change{ WorkAuthorization.all.length }.by(0)
      end

      it "does not send an email" do
        expect{ obj.process }.to change{ ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end

