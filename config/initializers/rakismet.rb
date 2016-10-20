# config/initializers/rakismet.rb

# Configure the Rakismet key and the URL of your application by setting the following
Progressivestack::Application.config.rakismet.key = ENV['rakismet_key']
Progressivestack::Application.config.rakismet.url = ENV['rakismet_url']
