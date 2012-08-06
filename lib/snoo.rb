require 'httparty'

%w{version exceptions utilities account flair links_comments listings moderation pms subreddits users}.each do |local|
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

    attr_reader(:modhash, :username, :userid, :cookies)


    # Creates a new instance of Snoo.
    #
    # Please change the useragent if you write your own program.
    #
    # @param url [String] url The base url of reddit.
    # @param useragent [String] The User-Agent this bot will use.
    def initialize( url = "http://www.reddit.com", useragent = "Snoo ruby reddit api wrapper v#{VERSION}" )
      @baseurl = url
      self.class.base_uri url
      @headers = {'User-Agent' => useragent }
      self.class.headers @headers
      @cookies = nil
      @modhash = nil
    end
  end
end
