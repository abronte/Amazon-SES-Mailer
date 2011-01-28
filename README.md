# Amazon SES Mailer
Implements Amazon SES API.

## Options
- `access_key`: your AWS access key
- `secret_key`: your AWS secret key
- `version`: API version
- `endpoint`: SES endpoint URL
- `host`: SES endpoint host

# Limitations
Currently it only supports raw message sending.

# Examples

Create a mailer instance

	mailer = AmazonSes::Mailer.new(secret_key: __, access_key: __)
    
Deliver a message

	mailer.deliver to:      'foo@example.com',
				   from:    'bar@example.com',
				   subject: 'This is a subject',
				   body:    'And this is the body'

Other delivery options
    
	mail = Mail.new { ... }
    m.deliver(mail)
    
	File.open('/path/to/raw/email') do |f|
      m.deliver(f.read)	
	end