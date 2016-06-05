require 'json'
require 'rubygems'
require 'oauth'
require 'certified'

#Get the keys and token from the config
configFile = File.read("../../TwitterConfig.json")
config = JSON.parse(configFile);

#create the authentication
consumer_key = OAuth::Consumer.new(
  config["consumer_key"]["public"],
  config["consumer_key"]["private"])
access_token = OAuth::Token.new(
  config["access_token"]["public"],
  config["access_token"]["private"])
  
#Define endpoint to hit as the Tweet endpoint
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/update.json"
address = URI("#{baseurl}#{path}")
request = Net::HTTP::Post.new address.request_uri
request.set_form_data(
  "status" => "Test Tweet, please ignore",
)

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Issue the request
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Build the request and authorize it with OAuth.
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token

# Parse and print the Tweet if the response code was 200
tweet = nil
if response.code == '200' then
  tweet = JSON.parse(response.body)
  puts "Successfully sent #{tweet["text"]}"
else
  puts "Could not send the Tweet! " +
  "Code:#{response.code} Body:#{response.body}"
end
