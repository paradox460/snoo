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
      post('/api/delete_sr_header', body: {r: subreddit, uh: @modhash})
    end

    # Deletes an image from a subreddit. This is for css, not removing posts
    #
    # @param (see #delete_header)
    # @param image_name [String] the image to delete from the subreddit. Can be obtained via {#get_stylesheet}
    # @return (see #clear_sessions)
    def delete_image subreddit, image_name
      logged_in?
      post('/api/delete_sr_image', body: {r: subreddit, img_name: image_name, uh: @modhash})
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
      bool = [true, false]
      raise ArgumentError, "type must be one of public, private, restricted, is #{opts[:type]}" unless %w{public private restricted}.include?(opts[:type]) or opts[:type].nil?
      raise ArgumentError, "post_type must be one of any, link, self; is #{opts[:link_type]}" unless %w{any link self}.include?(opts[:link_type]) or opts[:link_type].nil?
      raise ArgumentError, "allow_frontpage must be boolean" unless bool.include?(opts[:allow_top]) or opts[:allow_top].nil?
      raise ArgumentError, "show_media must be boolean" unless bool.include?(opts[:show_media]) or opts[:show_media].nil?
      raise ArgumentError, "adult must be boolean" unless bool.include?(opts[:over_18]) or opts[:over_18].nil?
      params = {
        type: 'public',
        link_type: 'any',
        lang: 'en',
        r: subreddit,
        uh: @modhash,
        allow_top: true,
        show_media: true,
        over_18: false,
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
      post('/api/subreddit_stylesheet', body: {op: "save", stylesheet_contents: stylesheet, uh: @modhash})
    end

    # Subscribe to a subreddit
    #
    # @param (see #delete_header)
    # @param action [sub, unsub] Subscribe or unsubscribe
    # @return (see #clear_sessions)
    def subscribe subreddit, action = "sub"
      logged_in?
      raise ArgumentError, "action must be one of sub, unsub; is #{action}" unless %w{sub unsub}.include?(action)
      post('/api/subscribe', body: {action: action, sr: subreddit, uh: @modhash})
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
      raise ArgumentError, "condition must be one of subscriber, contributor, moderator; is #{opts[:condition]}" unless %w{subscriber contributor moderator}.include?(opts[:condition]) or opts[:condition].nil?
      raise ArgumentError, "limit must be within 1..100; is #{opts[:limit]}" unless (1..100).include?(opts[:limit]) or opts[:limit].nil?
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
      raise ArgumentError, "condition must be one of popular, new, banned; is #{opts[:condition]}" unless %w{popular new banned}.include?(opts[:condition]) or opts[:condition].nil?
      raise ArgumentError, "limit must be within 1..100; is #{opts[:limit]}" unless (1..100).include?(opts[:limit]) or opts[:limit].nil?

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
      raise ArgumentError, "limit must be within 1..100; is #{opts[:limit]}" unless (1..100).include?(opts[:limit]) or opts[:limit].nil?

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
      friend_wrapper api_container = container, api_name = user, api_subreddit = subreddit, api_type = "moderator"
    end

    # Add a contributor to the subreddit
    #
    # @param (see #add_moderator)
    # @return (see #clear_sessions)
    def add_contributor container, user, subreddit
      friend_wrapper api_container = container, api_name = user, api_subreddit = subreddit, api_type = "contributor"
    end

    # Ban a user from a subreddit
    #
    # @param (see #add_moderator)
    # @return (see #clear_sessions)
    def ban_user container, user, subreddit
      friend_wrapper api_container = container, api_name = user, api_subreddit = subreddit, api_type ="banned"
    end

    # Remove a moderator from a subreddit
    #
    # @param id [String] The user id
    # @param (see #add_moderator)
    # @return (see #clear_sessions)
    def remove_moderator id, container, user, subreddit
      unfriend_wrapper api_id = id, api_container = container, api_name = user, api_subreddit = subreddit, api_type = "moderator"
    end

    # Remove a contributor from a subreddit
    #
    # @param (see #remove_moderator)
    # @return (see #clear_sessions)
    def remove_contributor id, container, user, subreddit
      unfriend_wrapper api_id = id, api_container = container, api_name = user, api_subreddit = subreddit, api_type = "contributor"
    end

    # Unban a user from a subreddit
    #
    # @param (see #remove_moderator)
    # @return (see #clear_sessions)
    def unban_user id, container, user, subreddit
      unfriend_wrapper api_id = id, api_container = container, api_name = user, api_subreddit = subreddit, api_type = "banned"
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
      post('/api/accept_moderator_invite', body: {r: subreddit, uh: @modhash})
    end
  end
end
