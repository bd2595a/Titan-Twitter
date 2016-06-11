require 'rubygems'
require 'ruby_reddit_api'

# Given a subreddit, return its top post
# Returns the top subreddit post object

class ParseReddit
	public
	# Gets a subreddit posts
	# subreddit - string subreddit name
	def self.get_top_subreddit_post(subreddit)
		subRedditPosts = get_subreddit_posts(subreddit)
		return subRedditPosts[0]
	end
		

	# Gets a subreddit posts
	# subreddit - string subreddit name
	# Returns an array of all the subreddit posts
	def self.get_subreddit_posts(subreddit)
		reddit = Reddit::Api.new "user", "password"
		return reddit.browse subreddit
	end
end