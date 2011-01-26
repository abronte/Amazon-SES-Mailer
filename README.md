# Amazon SES Mailer
Implements Amazon SES API.

# Limitations
Currently it only supports raw message sending.

# Examples

Create a mailer instance

	mailer = AmazonSES::Mailer.new(secret_key: __, access_key: __)
    
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