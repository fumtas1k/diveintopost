require "rails_helper"

RSpec.describe TeamMailer, type: :mailer do
  describe "transfer_owner_mail" do
    let(:mail) { TeamMailer.transfer_owner_mail }

    it "renders the headers" do
      expect(mail.subject).to eq("Transfer owner mail")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
