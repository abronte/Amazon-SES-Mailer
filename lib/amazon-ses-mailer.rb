require 'net/http'
require 'net/https'
require 'hmac'
require 'hmac-sha2'
require 'base64'
require 'cgi'

module AmazonSes
  class Mailer
    
    def initialize(opts)
      @version  = opts[:version]  || '2010-12-01'
      @endpoint = opts[:endpoint] || 'https://email.us-east-1.amazonaws.com/'
      @host     = opts[:host]     || 'email.us-east-1.amazonaws.com'
      
      raise "Access key needed" unless opts.key? :access_key
      raise "Secret key needed" unless opts.key? :secret_key
      
      @access_key = opts[:access_key]
      @secret_key = opts[:secret_key]
    end

    def deliver(msg)
      @time = Time.now

      http = Net::HTTP.new(@host, 443)
      http.use_ssl = true
      
      headers = { "x-amzn-authorization" => full_signature,
                  "Date"                 => sig_timestamp }
                  
      data = request_data(msg.to_s)

      http.post("/", data, headers).body
    end
    
    def deliver_async(msg)
      Thread.start do
        resp = deliver(msg)
        yield resp if block_given?
      end
    end

    private

    def request_data(msg)
      data = CGI::escape(Base64::encode64(msg))
      time = CGI::escape(url_timestamp)

      "AWSAccessKeyId=#{@access_key}&Action=SendRawEmail&RawMessage.Data=#{data}&Timestamp=#{time}&Version=#{@version}"
    end

    def url_timestamp
      @time.gmtime.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    end

    def sig_timestamp 
      @time.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')
    end

    def generate_sig
      msg = "#{sig_timestamp}"
      hmac = HMAC::SHA256.new(@secret_key)
      hmac.update(msg)
      Base64::encode64(hmac.digest).chomp
    end

    def full_signature
      "AWS3-HTTPS AWSAccessKey=#{@access_key}, Signature=#{generate_sig}, Algorithm=HmacSHA256"
    end
  end
end
