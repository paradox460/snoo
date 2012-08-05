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
    [Utilities,  Account, Flair, LinksComments, Listings, Moderation, PM, User, Subreddit].each do |inc|
      include inc
    end

    attr_reader(:username, :userid, :cookies)
    attr_accessor(:modhash)


    # Creates a new instance of Snoo.
    #
    # Please change the useragent if you write your own program.
    #
    # @param opts [Hash] An options hash
    # @option opts [String] :url The reddit url
    # @option opts [String] :useragent ("Snoo ruby reddit api wrapper v#{VERSION}") The useragent
    # @option opts [String] :cookies The cookies sent in the header
    # @option opts [String] :modhash The userauth modhash
    def initialize opts={}
      @baseurl = opts[:url] || "http://www.reddit.com"
      self.class.base_uri @baseurl
      @headers = {'User-Agent' => (opts[:useragent] || "Snoo ruby reddit api wrapper v#{VERSION}")}
      self.class.headers @headers
      set_cookies = opts[:cookies] || nil
      @modhash = opts[:modhash] || nil
    end
  end
end
