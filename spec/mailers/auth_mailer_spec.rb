require "spec_helper"

RSpec.describe AuthMailer, type: :mailer do
  describe "send_link" do
    let(:mail) { AuthMailer.send_link(create_auth_link_user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Access to UC San Diego SC&A Virtual Reading Room")
      expect(mail.to).to eq(["test@example.com"])
      expect(mail.from).to eq(["spcoll-request@ucsd.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Dear test@example.com")
    end
  end
end
