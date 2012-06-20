module Snoo
  class Client
    # @!group Links and Comments

    # Posts a comment to the site
    #
    # @param text [String] The comment text, formatted as markdown
    # @param id [String] The parent object id. Should be a comment or link
    # @return (see #clear_sessions)
    def comment text, id
      logged_in?
      self.class.post('/api/comment', body: { text: text, thing_id: id, uh: @modhash})
    end

    # Deletes a thing from the site
    #
    # @param id [String] The thing to target.
    # @return (see #clear_sessions)
    def delete id
      logged_in?
      self.class.post('/api/del', body: { id: id, uh: @modhash })
    end

    # Edits a thing.
    # Can be a self post body, or a comment
    #
    # @param (see #comment)
    # @return (see #clear_sessions)
    def edit text, id
      logged_in?
      self.class.post('/api/editusertext', body: {text: text, thing_id: id, uh: @modhash})
    end

    # Hides a thing
    #
    # @param (see #delete)
    # @return (see #clear_sessions)
    def hide id
      logged_in?
      self.class.post('/api/hide', body: {id: id, uh: @modhash})
    end

    # Get a listing of things which have the provided URL.
    # You can use a plain url, or a reddit link id to get reposts of said link
    # @note Using {#search} is probably better for url lookups
    # @note You do not have to be logged in to use this
    #
    # @param id [String] The id of a reddit thing to look up. Specify either this or a url, not both
    # @param url [String] The url to search for matching things. Specify either this or an id, not both
    # @param limit [Fixnum] The number of things to return. Go too high and the API will ignore you
    # @return (see #clear_sessions)
    def info id = nil, url = nil, limit = 100
      raise 'parameter error: url or id, not both' if id && url
      query = { limit: limit }
      query[:id] = id if id
      query[:url] = url if url
      self.class.get('/api/info.json', query: query)
    end

    # Marks a post NSFW. Currently, this only works on links
    #
    # @param (see #delete)
    # @return (see #clear_sessions)
    def mark_nsfw id
      logged_in?
      self.class.post('/api/marknsfw', body: {id: id, uh: @modhash})
    end

    # Reports a comment or link
    #
    # @param (see #delete)
    # @reutrn (see #comment)
    def report id
      logged_in?
      self.class.post('/api/report', body: {id: id, uh: @modhash})
    end

    # Saves a link
    #
    # @param (see #delete)
    # @return (see #clear_sessions)
    def save id
      logged_in?
      self.class.post('/api/save', body: { id: id, uh: @modhash})
    end

    # Submit a link or self post
    #
    # @param title [String] Title of the post
    # @param subreddit [String] The subreddit in which we are posting
    # @param url [String] The url for the post. If this is specified, it will not be a self post, and `text` will be ignored
    # @param text [String] The self-post text. Can be formatted in markdown
    # @return (see #clear_sessions)
    def submit title, subreddit, url = nil, text = nil
      logged_in?
      raise 'parameter error: either url or text, not both' if url && text
      post = {
        title: title,
        sr: subreddit,
        uh: @modhash
      }
      post[:kind] = (url ? "link" : "self")
      post[:url] = url if url
      post[:text] = text if text
      self.class.post('/api/submit', body: post)
    end

    # Unhide a thing
    #
    # @param (see #delete)
    # @return (see #clear_sessions)
    def unhide id
      logged_in?
      self.class.post('/api/unhide', body: {id: id, uh: @modhash})
    end

    # Un-mark NSFW a thing.
    #
    # @param (see #delete)
    # @return (see #clear_sessions)
    def unmark_nsfw id
      logged_in?
      self.class.post('/api/unmarknsfw', body: {id: id, uh: @modhash})
    end

    # Vote on a comment or link
    #
    # @param direction [-1, 0, 1] The direction to vote in. -1 is a downvote, 1 is an upvote, 0 cancels any vote
    # @param id [String] The thing to target.
    # @return (see #clear_sessions)
    def vote direction, id
      logged_in?
      raise "parameter error: direction needs to be one of -1, 0, or 1 (was #{direction}" unless (-1..1).include?(direction)
      self.class.post('/api/vote', body: {id: id, dir: direction, uh: @modhash})
    end


  end
end
