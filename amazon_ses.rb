require 'net/http'
require 'net/https'
require 'hmac'
require 'hmac-sha2'
require 'base64'
require 'cgi'

class AmazonSES 
  @@version = '2010-12-01'
  @@end_point = 'https://email.us-east-1.amazonaws.com/'
  @@host = "email.us-east-1.amazonaws.com"
  @@aws_access = "YOUR AWS ACCESS KEY"
  @@aws_secret = "YOUR AWS SECRET KEY"
  @@time = nil

  def deliver(msg)
    @@time = Time.now
    
    http = Net::HTTP.new(@@host, 443)
    http.use_ssl = true
    headers = { "x-amzn-authorization" => full_signature, "Date" =>  sig_timestamp}
    data = request_data(msg)

    resp = http.post("/", data, headers)

    puts resp.body
  end

  private

  def request_data(msg)
    data = CGI::escape(Base64::encode64(msg))
    time = CGI::escape(url_timestamp)

    "AWSAccessKeyId=#{@@aws_access}&Action=SendRawEmail&RawMessage.Data=#{data}&Timestamp=#{time}&Version=#{@@version}"
  end

  def url_timestamp
    @@time.gmtime.strftime('%Y-%m-%dT%H:%M:%S.000Z')
  end

  def sig_timestamp 
    @@time.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')
  end

  def generate_sig
    msg = "#{sig_timestamp}"
    hmac = HMAC::SHA256.new(@@aws_secret)
    hmac.update(msg)
    Base64::encode64(hmac.digest).chomp
  end

  def full_signature
    "AWS3-HTTPS AWSAccessKey=#{@@aws_access}, Signature=#{generate_sig}, Algorithm=HmacSHA256"
  end

end