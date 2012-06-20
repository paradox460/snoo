require 'httparty'

require "snoo/version"
require "snoo/utilities"
require "snoo/account"
require "snoo/flair"
require "snoo/links_comments"
require "snoo/listings"
require "snoo/moderation"
require "snoo/pms"
require "snoo/subreddits"
require "snoo/users"

# Snoo reddit API wrapper
#
# @author Jeff Sandberg <paradox460@gmail.com>
module Snoo
  # Snoo reddit API wrapper
  #
  # @author Jeff Sandberg <paradox460@gmail.com>
  class Snoo
    include HTTParty

    # Creates a new instance of Snoo
    #
    # @param url [String] url The base url of reddit.
    # @param useragent [String] The User-Agent this bot will use.
    def initialize( url = "http://www.reddit.com", useragent = "Snoo ruby reddit api wrapper v#{VERSION}" )
      @baseurl = url
      @headers[:useragent] = useragent
      base_uri url
      headers 'User-Agent' => useragent
    end
  end
end
