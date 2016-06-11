require 'json'
require 'rubygems'
require 'twitter'
require 'certified'

class SendTweet

	private 
	# Configuration
	configFile = File.read("../../TwitterAuthenticationConfig.json")
	configuration = JSON.parse(configFile);

	# Twitter client
	@client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = configuration["consumer_key"]["public"]
	  config.consumer_secret     = configuration["consumer_key"]["private"]
	  config.access_token        = configuration["access_token"]["public"]
	  config.access_token_secret = configuration["access_token"]["private"]
	end
	
	public
	
	# Sends a tweet
	# tweet_text - string text to tweet
	def self.send_tweet(tweet_text)
		@client.update(tweet_text)
	end
end