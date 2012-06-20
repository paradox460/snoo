module Snoo
  class Client
    # @!group Page listings

    # Get a comment listing from the site
    #
    # @param link_id [String] The link id of the comment thread. Must always be present
    # @param comment_id [String] The parent comment of a thread.
    # @param context [Fixnum] The context of the thread, that is, how far above the `comment_id` to return
    # @param limit [Fixnum] The total number of comments to return. If you have gold this can include the whole thread, but is buggy. Recommend no more than 1000
    # @param depth [Fixnum] How deep to render a comment thread.
    # @param sort [old, new, hot, top, controversial, best] The sort used.
    # @return (see #clear_sessions)
    def get_comments link_id, comment_id = nil, context = nil, limit = 100, depth = nil, sort = nil
      sorts = %w{old new hot top controversial best}
      raise "parameter error: sort cannot be #{sort}" unless sorts.include?(sort) or sort.nil?
      query = {}
      query[:context] = context if context
      query[:limit] = limit if limit
      query[:depth] = depth if depth
      query[:sort] = sort if sort
      url = "/comments/%s%s.json" % [link_id, ('/' + comment_id if comment_id)]
      self.class.get(url, query: query)
    end

    # Gets a listing of links from reddit.
    #
    # @param subreddit [String] The subreddit targeted. Can be psuedo-subreddits like `all` or `mod`
    # @param page [new, controversial, top] The page to view.
    # @param sort [new, rising] The sorting method. Only relevant on the `new` page
    # @param time [hour, day, week, month, year] The timeframe. Only relevant on some pages, such as `top`. Leave empty for all time
    # @param limit [1..100] The number of things to return.
    # @param after [String] Get things *after* this thing id
    # @param before [String] Get things *before* this thing id
    # @return (see #clear_sessions)
    def get_listing subreddit = nil, page = nil, sort = nil, time = nil, limit = nil, after = nil, before = nil
      pages = %w{new controversial top}
      sorts = %w{new rising}
      times = %w{hour day week month year}
      # Invalid Page
      raise "parameter error: page must be #{pages * ', '}, is #{page}" unless pages.include?(page) or page.nil?
      # Invalid Sort
      raise "parameter error: sort must be one of #{sorts * ', '}, is #{sort}" unless sorts.include?(sort) or sort.nil?
      # Sort on useless page
      raise "parameter error: sort can only be used on page = 'new'" if page != 'new' && sort
      # Invalid time
      raise "parameter error: time can only be one of #{times * ', '}, is #{time}" unless times.include?(time) or time.nil?
      # Invalid limit
      raise "parameter error: limit cannot be outside 1..100, is #{limit}" unless (1..100).include?(limit) or limit.nil?

      # Build the basic url
      url = "%s/%s.json" % [('/r/' + subreddit if subreddit ), (page if page)]
      # Assemble the query
      query = {}

      query[:sort] = sort if sort
      query[:t] = time if time
      query[:limit] = limit if limit
      query[:after] = after if after
      query[:before] = before if before

      # Make the request
      self.class.get(url, query: query)
    end

    # Search reddit
    #
    # @param query [String] The search query.
    # @param restrict_subreddit [true, false] Restrict to the calling subreddit
    # @param subreddit [String] The calling subreddit.
    # @param limit [1..100] The amount of results to return
    # @param before [String] Return things *before* this id
    # @param after [String] Return things *after* this id
    # @param sort [relevance, new, top] The sorting of the results.
    # @param syntax [cloudsearch, lucene] The search syntax.
    # @return (see #clear_sessions)
    def search query, restrict_subreddit = false, subreddit = nil, limit = nil, before = nil, after = nil, sort = nil, syntax = 'lucene'
      raise 'parameter error: restrict_subreddit needs to be boolean' unless [true, false].include?(restrict_subreddit)
      raise "parameter error: limit needs to be 1..100, is #{limit}" unless (1..100).include?(limit) or limit.nil?
      raise "parameter error: sort needs to be one of relevance, new, top, is #{sort}" unless %w{relevance new top}.include?(sort) or sort.nil?
      raise "parameter error: syntax needs to be one of cloudsearch, lucene; is #{syntax}" if %w{cloudsearch lucene}.include?(syntax)

      # This supports searches with and without a subreddit
      url = "%s/search.json" % (subreddit if subreddit)

      # Construct the query
      httpquery = {
        q: query
      }
      httpquery[:restrict_sr] = (restrict_subreddit ? "on" : "off")
      httpquery[:limit] = limit if limit
      httpquery[:before] = before if before
      httpquery[:after] = after if after
      httpquery[:sort] = sort if sort
      httpquery[:syntax] = syntax if syntax != 'lucene'

      self.class.get(url, query: httpquery)
    end
  end
end
