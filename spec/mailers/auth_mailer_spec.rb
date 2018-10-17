require "rails_helper"

RSpec.describe AuthMailer, type: :mailer do
  describe "send_link" do
    let(:mail) { AuthMailer.send_link }

    it "renders the headers" do
      expect(mail.subject).to eq("Send link")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
