module Snoo
  # Methods for getting thing listings. Comments, links, etc
  #
  # @author (see Snoo)
  module Listings

    # Get a comment listing from the site
    #
    # @param (see LinksComments#info)
    # @option opts [String] :subreddit The subreddit to fetch the comments of
    # @option opts [String] :link_id The link to get the comments of
    # @option opts [String] :comment_id The parent comment of a thread.
    # @option opts [Fixnum] :context The context of the thread, that is, how far above the `comment_id` to return
    # @option opts [Fixnum] :limit (100) The total number of comments to return. If you have gold this can include the whole thread, but is buggy. Recommend no more than 1000
    # @option opts [Fixnum] :depth How deep to render a comment thread.
    # @option opts [old, new, hot, top, controversial, best] :sort The sort used.
    # @return (see #clear_sessions)
    def get_comments opts = {}
      query = { limit: 100 }
      query.merge! opts
      url = "%s/comments/%s%s.json" % [('/r/' + opts[:subreddit] if opts[:subreddit]), opts[:link_id], ('/blah/' + opts[:comment_id] if opts[:comment_id])]
      get(url, query: query)
    end

    # Gets a listing of links from reddit.
    #
    # @param (see LinksComments#info)
    # @option opts [String] :subreddit The subreddit targeted. Can be psuedo-subreddits like `all` or `mod`. If blank, the front page
    # @option opts [new, controversial, top, saved] :page The page to view.
    # @option opts [new, rising] :sort The sorting method. Only relevant on the `new` page
    # @option opts [hour, day, week, month, year] :t The timeframe. Only relevant on some pages, such as `top`. Leave empty for all time
    # @option opts [1..100] :limit The number of things to return.
    # @option opts [String] :after Get things *after* this thing id
    # @option opts [String] :before Get things *before* this thing id
    # @return (see #clear_sessions)
    def get_listing opts = {}
      # Build the basic url
      url = "%s/%s.json" % [('/r/' + opts[:subreddit] if opts[:subreddit] ), (opts[:page] if opts[:page])]
      # Delete subreddit and page from the hash, they dont belong in the query
      [:subreddit, :page].each {|k| opts.delete k}
      query = opts
      # Make the request
      get(url, query: query)
    end

    # Search reddit
    #
    # @param query [String] The search query.
    # @param (see LinksComments#info)
    # @option opts [true, false] :restrict_sr Restrict to the calling subreddit
    # @option opts [String] :subreddit The calling subreddit.
    # @option opts [1..100] :limit The amount of results to return
    # @option opts [String] :before Return things *before* this id
    # @option opts [String] :after Return things *after* this id
    # @option opts [relevance, new, top] :sort The sorting of the results.
    # @option opts [cloudsearch, lucene] :syntax The search syntax.
    # @return (see #clear_sessions)
    def search query, opts = {}
      # This supports searches with and without a subreddit
      url = "%s/search.json" % ('/r/' + opts[:subreddit] if opts[:subreddit])

      # Construct the query
      httpquery = {q: query}
      opts.delete :subreddit
      httpquery.merge! opts

      get(url, query: httpquery)
    end
  end
end
