module Snoo
  # Methods for administering a subreddit, as well as looking up subreddits (subreddit search)
  #
  # @author (see Snoo)
  module Subreddit

    # Deletes the header image of a subreddit
    #
    # @param subreddit [String] The subreddit targeted
    # @return (see #clear_sessions)
    def delete_header subreddit
      logged_in?
      post('/api/delete_sr_header', body: {r: subreddit, uh: @modhash, api_type: 'json'})
    end

    # Deletes an image from a subreddit. This is for css, not removing posts
    #
    # @param (see #delete_header)
    # @param image_name [String] the image to delete from the subreddit. Can be obtained via {#get_stylesheet}
    # @return (see #clear_sessions)
    def delete_image subreddit, image_name
      logged_in?
      post('/api/delete_sr_image', body: {r: subreddit, img_name: image_name, uh: @modhash, api_type: 'json'})
    end

    # Gets a hash of the subreddit settings
    # Returns a webserver error (404) if you don't have moderator permissions on said subreddit
    #
    # @param subreddit [String] the subreddit to fetch data from
    def get_subreddit_settings subreddit
      logged_in?
      get("/r/#{subreddit}/about/edit/.json")
    end
    # @todo test if every param is actually required
    # Sets subreddit settings.
    #
    # @param (see #delete_header)
    # @param (see LinksComments#info)
    # @option opts [String] :title The subreddit's title
    # @option opts [String] :public_description The subreddit's public description
    # @option opts [String] :description The subreddit's sidebar
    # @option opts [String] :lang (en) The default language. ISO language code
    # @option opts [public, private, restricted] :type (public) The subreddits type
    # @option opts [any, link, self] :link_type (any) The type of posts allowed on this subreddit
    # @option opts [true, false] :allow_top (true) Allow this subreddit to appear on the front page
    # @option opts [true, false] :show_media (true) show thumbnails and media embeds
    # @option opts [String] :header-title The header mouse-over text
    # @option opts [true, false] :over_18 (false) If the subreddit requires over 18 access
    # @return (see #clear_sessions)
    def subreddit_settings subreddit, opts = {}
      logged_in?
      params = {
        type: 'public',
        link_type: 'any',
        lang: 'en',
        r: subreddit,
        uh: @modhash,
        allow_top: true,
        show_media: true,
        over_18: false,
        api_type: 'json'
      }
      params.merge! opts
      post('/api/site_admin', body: params)
    end

    # Set the subreddit stylesheet
    #
    # @param stylesheet [String] The stylesheet for the subreddit. Overwrites the current one
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def set_stylesheet stylesheet, subreddit
      logged_in?
      post('/api/subreddit_stylesheet', body: {op: 'save', r: subreddit, stylesheet_contents: stylesheet, uh: @modhash, api_type: 'json'})
    end

    # Subscribe to a subreddit
    #
    # @param (see #delete_header)
    # @param action [sub, unsub] Subscribe or unsubscribe
    # @return (see #clear_sessions)
    def subscribe subreddit, action = "sub"
      logged_in?
      post('/api/subscribe', body: {action: action, sr: subreddit, uh: @modhash, api_type: 'json'})
    end

    # Unsubscribe from a subreddit
    # This is an alias for `subscribe "unsub"`
    #
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def unsubscribe subreddit
      subscribe("unsub", subreddit)
    end


    # Get subreddit info
    #
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def subreddit_info subreddit
      get("/r/#{subreddit}/about.json")
    end

    # Get subreddit stylesheet and images
    #
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def get_stylesheet subreddit
      logged_in?
      get("/r/#{subreddit}/about/stylesheet.json")
    end

    # Get subreddits I have
    #
    # @param (see LinksComments#info)
    # @option opts [subscriber, contributor, moderator] :condition The permission level to return subreddits from
    # @option opts [1..100] :limit The number of results to return
    # @option opts [String] :after Return subreddits *after* this id
    # @option opts [String] :before Return subreddits *before* this id
    # @return (see #clear_sessions)
    def my_reddits opts = {}
      logged_in?
      url = "/reddits/mine/%s.json" % (opts[:condition] if opts[:condition])
      opts.delete :condition
      query = opts
      get(url, query: query)
    end

    # Get a list of subreddits
    #
    # @param (see LinksComments#info)
    # @option opts [popular, new, banned] :condition The type of subreddits to return
    # @option opts [1..100] :limit The number of results to return
    # @option opts [String] :after Return subreddits *after* this id.
    # @option opts [String] :before Return subreddits *before* this id.
    # @return (see #clear_sessions)
    def get_reddits opts = {}
      url = "/reddits/%s.json" % (opts[:condition] if opts[:condition])
      opts.delete :condition
      query = opts

      get(url, query: query)
    end

    # Search subreddits
    #
    # @param q [String] The search query
    # @param (see LinksComments#info)
    # @option opts [1..100] :limit The number of results to return
    # @option opts [String] :after Return subreddits *after* this id.
    # @option opts [String] :before Return subreddits *before* this id.
    # @return (see #clear_sessions)
    def search_reddits q, opts = {}
      query = {q: q}
      query.merge! opts
      get('/reddits/search.json', query: query)
    end

    # Add a moderator to the subreddit
    #
    # @param container [String] The subreddit id. Must be a subreddit id (begins with t5_)
    # @param user [String] The user
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def add_moderator container, user, subreddit
      friend_wrapper container: container, name: user, r: subreddit, type: "moderator"
    end

    # Add a contributor to the subreddit
    #
    # @param (see #add_moderator)
    # @return (see #clear_sessions)
    def add_contributor container, user, subreddit
      friend_wrapper container: container, name: user, r: subreddit, type: "contributor"
    end

    # Ban a user from a subreddit
    #
    # @param (see #add_moderator)
    # @return (see #clear_sessions)
    def ban_user container, user, subreddit
      friend_wrapper container: container, name: user, r: subreddit, type: "banned"
    end

    # Remove a moderator from a subreddit
    #
    # @param (see #add_moderator)
    # @return (see #clear_sessions)
    def remove_moderator container, user, subreddit
      unfriend_wrapper container: container, name: user, r: subreddit, type: "moderator"
    end

    # Remove a contributor from a subreddit
    #
    # @param (see #remove_moderator)
    # @return (see #clear_sessions)
    def remove_contributor container, user, subreddit
      unfriend_wrapper container: container, name: user, r: subreddit, type: "contributor"
    end

    # Unban a user from a subreddit
    #
    # @param (see #remove_moderator)
    # @return (see #clear_sessions)
    def unban_user container, user, subreddit
      unfriend_wrapper container: container, name: user, r: subreddit, type: "banned"
    end

    # List moderators of a subreddit
    #
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def get_moderators subreddit
      get("/r/#{subreddit}/about/moderators.json")
    end

    # List contributors of a subreddit
    #
    # @param (see #delete_header)
    # @param (see #clear_sessions)
    def get_contributors subreddit
      logged_in?
      get("/r/#{subreddit}/about/contributors.json")
    end

    # List banned users of a subreddit
    #
    # @param (see #delete_header)
    # @param (see #clear_sessions)
    def get_banned_users subreddit
      logged_in?
      get("/r/#{subreddit}/about/banned.json")
    end

    # Accept a moderatorship
    #
    # @param subreddit [String] The subreddit to accept in. You must have been invited
    def accept_moderator subreddit
      logged_in?
      post('/api/accept_moderator_invite', body: {r: subreddit, uh: @modhash, api_type: 'json'})
    end
  end
end
