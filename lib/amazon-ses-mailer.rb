require 'net/http'
require 'net/https'
require 'hmac'
require 'hmac-sha2'
require 'base64'
require 'cgi'
require 'mail'

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
    
    ##### Start ActionMailer-specific stuff #####
    attr_accessor :settings
    
    def new(*args)
      self
    end
    
    def deliver!(msg)
      deliver(msg)
    end
    ##### End ActionMailer-specific stuff #####

    def deliver(msg)
      @time = Time.now
      
      if @endpoint.start_with? 'https'
        http = Net::HTTP.new(@host, 443)
        http.use_ssl = true
      else
        http = Net::HTTP.new(@host)
      end
      
      headers = { "x-amzn-authorization" => full_signature,
                  "Date"                 => sig_timestamp }
                  
      data = request_data(msg)

      http.post("/", data, headers).body
    end

    private

    def request_data(msg)
            
      msg_str = if Hash === msg
        Mail.new(msg).to_s
      else
        msg.to_s
      end
      
      data = CGI::escape(Base64::encode64(msg_str))
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
