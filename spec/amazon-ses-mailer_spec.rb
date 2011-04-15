require "spec_helper"

describe AmazonSes::Mailer do
  subject { AmazonSes::Mailer.new(:access_key => "abc", :secret_key => "123") }
  let(:mail) { mock(:mail).as_null_object }

  before do
    FakeWeb.register_uri :post, "https://email.us-east-1.amazonaws.com/", :body => "Success"
  end

  context "attributes" do
    it "requires access key" do
      expect {
        AmazonSes::Mailer.new(:secret_key => "123")
      }.to raise_error(ArgumentError, "Access key needed")
    end

    it "requires secret key" do
      expect {
        AmazonSes::Mailer.new(:access_key => "abc")
      }.to raise_error(ArgumentError, "Secret key needed")
    end

    context "defaults" do
      its(:version) { should == "2010-12-01" }
      its(:endpoint) { should == "https://email.us-east-1.amazonaws.com/" }
      its(:host) { should == "email.us-east-1.amazonaws.com" }
    end

    context "set by user" do
      subject {
        AmazonSes::Mailer.new(
          :access_key => "abc",
          :secret_key => "123",
          :version => "2020-12-01",
          :endpoint => "http://aws.amazon.com/custom/",
          :host => "aws.amazon.com",
        )
      }

      its(:version) { should == "2020-12-01" }
      its(:endpoint) { should == "http://aws.amazon.com/custom/" }
      its(:host) { should == "aws.amazon.com" }
    end
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
