module Snoo
  # Methods for getting thing listings. Comments, links, etc
  #
  # @author (see Snoo)
  module Listings

    # Get a comment listing from the site
    #
    # @param link_id [String] The link id of the comment thread. Must always be present
    # @param (see LinksComments#info)
    # @option opts [String] :comment_id The parent comment of a thread.
    # @option opts [Fixnum] :context The context of the thread, that is, how far above the `comment_id` to return
    # @option opts [Fixnum] :limit (100) The total number of comments to return. If you have gold this can include the whole thread, but is buggy. Recommend no more than 1000
    # @option opts [Fixnum] :depth How deep to render a comment thread.
    # @option opts [old, new, hot, top, controversial, best] :sort The sort used.
    # @return (see #clear_sessions)
    def get_comments link_id, opts = {}
      sorts = %w{old new hot top controversial best}
      raise ArgumentError, "sort cannot be #{sort}" unless sorts.include?(opts[:sort]) or opts[:sort].nil?
      query = { limit: 100 }
      query.merge! opts
      url = "/comments/%s%s.json" % [link_id, ('/' + opts[:comment_id] if opts[:comment_id])]
      get(url, query: query)
    end

    # Gets a listing of links from reddit.
    #
    # @param (see LinksComments#info)
    # @option opts [String] :subreddit The subreddit targeted. Can be psuedo-subreddits like `all` or `mod`. If blank, the front page
    # @option opts [new, controversial, top] :page The page to view.
    # @option opts [new, rising] :sort The sorting method. Only relevant on the `new` page
    # @option opts [hour, day, week, month, year] :t The timeframe. Only relevant on some pages, such as `top`. Leave empty for all time
    # @option opts [1..100] :limit The number of things to return.
    # @option opts [String] :after Get things *after* this thing id
    # @option opts [String] :before Get things *before* this thing id
    # @return (see #clear_sessions)
    def get_listing opts = {}
      pages = %w{new controversial top}
      sorts = %w{new rising}
      times = %w{hour day week month year}
      # Invalid Page
      raise ArgumentError, "page must be #{pages * ', '}, is #{opts[:page]}" unless pages.include?(opts[:page]) or opts[:page].nil?
      # Invalid Sort
      raise ArgumentError, "sort must be one of #{sorts * ', '}, is #{opts[:sort]}" unless sorts.include?(opts[:sort]) or opts[:sort].nil?
      # Sort on useless page
      raise ArgumentError, "sort can only be used on page = 'new'" if opts[:page] != 'new' && opts[:sort]
      # Invalid time
      raise ArgumentError, "time can only be one of #{times * ', '}, is #{opts[:time]}" unless times.include?(opts[:time]) or opts[:time].nil?
      # Invalid limit
      raise ArgumentError, "limit cannot be outside 1..100, is #{opts[:limit]}" unless (1..100).include?(opts[:limit]) or opts[:limit].nil?

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
      raise ArgumentError, 'restrict_subreddit needs to be boolean' unless [true, false].include?(opts[:restrict_sr]) or opts[:restrict_sr].nil?
      raise ArgumentError, "limit needs to be 1..100, is #{opts[:limit]}" unless (1..100).include?(opts[:limit]) or opts[:limit].nil?
      raise ArgumentError, "sort needs to be one of relevance, new, top, is #{opts[:sort]}" unless %w{relevance new top}.include?(opts[:sort]) or opts[:sort].nil?
      raise ArgumentError, "syntax needs to be one of cloudsearch, lucene; is #{opts[:syntax]}" if %w{cloudsearch lucene}.include?(opts[:syntax])

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
