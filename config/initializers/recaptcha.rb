# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.public_key  = ENV['recaptcha_public']
  config.private_key = ENV['recaptcha_secret']
  config.hostname = ENV['hostname']
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end