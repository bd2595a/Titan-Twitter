require 'json'
require 'rubygems'
require 'certified'
require_relative 'parse_reddit.rb'
require_relative 'send_tweet.rb'

# Checks if the most recent post is a new update.
# If the most recent post is a new update, then tweet

class CheckRedditUpdate
	private
			# Get the config
  @config_file_name = "RedditConfig.json"
	@config_file = File.read(@config_file_name)
	@config = JSON.parse(@config_file);
	
	# Checks if it is the desired post and it is greater than the previous update
	# Returns bool true if valid, else false
	def self.validate_post(top_post)
		if is_desired_post(top_post)
			if update_version(top_post)
				return true
			end
		end
		return false
	end

	# Checks if the post matches the post with an update
	# Returns true if it matches the config matchText, else false
	def self.is_desired_post(top_post)
		return top_post.title.include? @config["matchText"]
	end

	# Gets the number from the post
	# Returns int in the post
	def self.get_version(top_post)
		return top_post.title.scan(/[0-9]/).join.to_i
	end

	# Checks if the post's update number is greater than the stored update number
	# Returns true if the version is more recent, else false
	def self.update_version(top_post)
    previous_version = @config["latestVersion"]
    current_version = get_version(top_post)
    
    if current_version > previous_version
      @config["latestVersion"] = current_version
      File.open(@config_file_name, 'r+') do |file|
        file.puts @config.to_json
      end
      return true
    end
    
		return false
	end

	public

	#Checks the top post in the subreddit and tweets if it is an update
	def self.CheckUpdate
		# Get the subreddit desired
		subreddit = @config["subredditName"];

		# Get the top post
		top_post = ParseReddit.get_top_subreddit_post(subreddit)

		# Validate the post. If there is no update don't tweet about it
		if !self.validate_post(top_post)
			return "No update to do"
		end

    latest_version = @config["latestVersion"].to_s
    url = @config["tweetUrl"]
    tweetText = "Hey @pikero24 read chapter " + latest_version +" at " + url + latest_version + ". Reddit at: " + top_post.url
		SendTweet.send_tweet(tweetText)
    return "There is an update with chapter " + latest_version + "!"
	end
end

