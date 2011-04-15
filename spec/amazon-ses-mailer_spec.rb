require "spec_helper"

describe AmazonSes::Mailer do
  subject { AmazonSes::Mailer.new(:access_key => "abc", :secret_key => "123") }
  let(:mail) { mock(:mail).as_null_object }

  before do
    FakeWeb.register_uri :post, "https://email.us-east-1.amazonaws.com/", :body => "Success"
  end

  context "using Rails" do
    it "logs response when is available" do
      Object.const_set "Rails", Module.new
      ::Rails.stub :logger => mock(:logger)

      ::Rails.logger.should_receive(:debug).with("Success")
      subject.deliver(mail)

      Object.class_eval { remove_const "Rails" }
    end

    it "doesn't raise exception when is not available" do
      expect { subject.deliver(mail) }.to_not raise_error
    end
  end
end
