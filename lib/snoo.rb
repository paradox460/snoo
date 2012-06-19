require 'httparty'

require "snoo/version"
require "snoo/utilities"
require "snoo/account"

module Snoo
  class Snoo
    include HTTParty

    # Creates a new instance of Snoo
    #
    # @param url [String] url The base url of reddit. Defaults to http://www.reddit.com
    # @param useragent [String] The User-Agent this bot will use.
    def initialize( url = "http://www.reddit.com", useragent = "Snoo ruby reddit api wrapper v#{VERSION}" )
      @baseurl = url
      @headers[:useragent] = useragent
      base_uri url
      headers 'User-Agent' => useragent
    end
  end
end
