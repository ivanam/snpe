# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.public_key  = '6Ldm5nAUAAAAAKZGH0NaSLQcoZsV3ArJYlS0r2p2'
  config.private_key = '6Ldm5nAUAAAAAEOEcz014T0gvRd6-DiYNvAMF3bC'
  # Uncomment the following line if you are using a proxy server:

  # config.proxy = 'http://myproxy.com.au:8080'
end