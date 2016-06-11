require 'rubygems'
require 'ruby_reddit_api'

# Given a subreddit, return its top post
# Returns the top subreddit post object
def get_top_subreddit_post
	subreddit = "ShingekiNoKyojin"
	subRedditPosts = get_titan_subreddit(subreddit)
	return subreddit[0]
end
	

# Gets a subreddit posts
# subreddit - ruby_reddit_api subreddit object
# Returns an array of all the subreddit posts
def get_subreddit_posts(subreddit)
	reddit = Reddit::Api.new "user", "password"
	return reddit.browse subreddit
end