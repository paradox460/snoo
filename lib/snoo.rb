require 'httparty'

%w{version utilities account flair links_comments listings moderation pms subreddits users}.each do |local|
  require "snoo/#{local}"
end
# Snoo reddit API wrapper
#
# @author Jeff Sandberg <paradox460@gmail.com>
module Snoo
  # Snoo reddit API wrapper
  #
  # @author (see Snoo)
  class Client
    include HTTParty
    [Account, Flair, LinksComments, Listings, Moderation, PM, Utilities, User, Subreddit].each do |inc|
      include inc
    end


    # Creates a new instance of Snoo
    #
    # @param url [String] url The base url of reddit.
    # @param useragent [String] The User-Agent this bot will use.
    def initialize( url = "http://www.reddit.com", useragent = "Snoo ruby reddit api wrapper v#{VERSION}" )
      @baseurl = url
      self.class.base_uri url
      @headers = {useragent: useragent }
      self.class.headers 'User-Agent' => useragent
    end
  end
end

