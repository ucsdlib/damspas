require "spec_helper"

RSpec.describe AuthMailer, type: :mailer do
  describe "send_link" do
    let(:mail) { AuthMailer.send_link(create_auth_link_user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Login Link Request")
      expect(mail.to).to eq(["test@example.com"])
      expect(mail.from).to eq(["dams@ucsd.edu"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello test@example.com!")
    end
  end
end
