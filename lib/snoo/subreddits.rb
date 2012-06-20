module Snoo
  class Snoo
    # Deletes the header image of a subreddit
    #
    # @param subreddit [String] The subreddit targeted
    # @return (see #clear_sessions)
    def delete_header subreddit
      logged_in?
      self.class.post('/api/delete_sr_header', body: {r: subreddit, uh: @modhash})
    end

    # Deletes an image from a subreddit. This is for css, not removing posts
    #
    # @param (see #delete_header)
    # @param image_name [String] the image to delete from the subreddit. Can be obtained via {#get_stylesheet}
    # @return (see #clear_sessions)
    def delete_image subreddit, image_name
      logged_in?
      self.class.post('/api/delete_sr_image', body: {r: subreddit, img_name: image_name, uh: @modhash})
    end

    # @todo test if every param is actually required
    # Sets subreddit settings.
    # @note You **must** fill out every paramiter, otherwise they will return to reddit defaults
    #
    # @param title [String] The subreddit's title
    # @param description [String] The subreddit's public description
    # @param sidebar [String] The subreddit's sidebar
    # @param lang [String] The default language. ISO language code
    # @param type [public, private, restricted] The subreddits type
    # @param post_type [any, link, self] The type of posts allowed on this subreddit
    # @param allow_frontpage [true, false] Allow this subreddit to appear on the front page
    # @param show_media [true, false] Show thumbnails and media embeds
    # @param header [String] The header mouse-over text
    # @param adult [true, false] If the subreddit requires over 18 access
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def subreddit_settings title, description = nil, sidebar = nil, lang = en, type = 'public', post_type = 'any', allow_frontpage = true, show_media = true, header = nil, adult = false, subreddit
      logged_in?
      bool = [true, false]
      raise "parameter error: type must be one of public, private, restricted, is #{type}" unless %w{public private restricted}.include?(type)
      raise "parameter error: post_type must be one of any, link, self; is #{type}" unless %w{any link self}.include?(post_type)
      raise "parameter error: allow_frontpage must be boolean" unless bool.include?(allow_frontpage)
      raise "parameter error: show_media must be boolean" unless bool.include?(show_media)
      raise "parameter error: adult must be boolean" unless bool.include?(adult)
      params = {title: title, description: sidebar, public_description: description, lang: lang, type: type, link_type: post_type, allow_top: allow_frontpage, show_media: show_media, "header-title" => header, r: subreddit, uh: @modhash}
      self.class.post('/api/site_admin', body: params)
    end

    # Set the subreddit stylesheet
    #
    # @param stylesheet [String] The stylesheet for the subreddit. Overwrites the current one
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def set_stylesheet stylesheet, subreddit
      logged_in?
      self.class.post('/api/subreddit_stylesheet', body: {op: "save", stylesheet_contents: stylesheet, uh: @modhash})
    end

    # Subscribe to a subreddit
    #
    # @param action [sub, unsub] Subscribe or unsubscribe
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def subscribe action = "sub", subreddit
      logged_in?
      raise "parameter error: action must be one of sub, unsub; is #{action}" unless %w{sub unsub}.include?(action)
      self.class.post('/api/subscribe', body: {action: action, sr: subreddit, uh: @modhash})
    end

    # Unsubscribe from a subreddit
    # This is an alias for `subscribe "unsub"…`
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
      self.class.get("/r/#{subreddit}/about.json")
    end

    # Get subreddit stylesheet and images
    #
    # @param (see #delete_header)
    # @return (see #clear_sessions)
    def get_stylesheet subreddit
      logged_in?
      self.class.get("/r/#{subreddit}/about/stylesheet.json")
    end

    # Get subreddits I have
    #
    # @param condition [subscriber, contributor, moderator] The permission level to return subreddits from
    # @param limit [1..100] The number of results to return
    # @param after [String] Return subreddits *after* this id
    # @param before [String] Return subreddits *before* this id
    # @return (see #clear_sessions)
    def my_reddits condition = nil, limit = nil, after = nil, before = nil
      logged_in?
      raise "parameter error: condition must be one of subscriber, contributor, moderator; is #{condition}" unless %w{subscriber contributor moderator}.include?(condition) or condition.nil?
      raise "parameter error: limit must be within 1..100; is #{limit}" unless (1..100).include?(limit) or limit.nil?
      query = {}
      query[:limit] = limit if limit
      query[:after] = after if after
      query[:before] = before if before
      url = "/reddits/mine/%s.json" % (condition if condition)
      self.class.get(url, query: query)
    end

    # Get a list of subreddits
    #
    # @param condition [popular, new, banned] The type of subreddits to return
    # @param limit [1..100] The number of results to return
    # @param after [String] Return subreddits *after* this id.
    # @param before [String] Return subreddits *before* this id.
    # @return (see #clear_sessions)
    def get_reddits condition = nil, limit = nil, after = nil, before = nil
      raise "parameter error: condition must be one of popular, new, banned; is #{condition}" unless %w{popular new banned}.include?(condition) or condition.nil?
      raise "parameter error: limit must be within 1..100; is #{limit}" unless (1..100).include?(limit) or limit.nil?

      url = "/reddits/%s.json" % (condition if condition)
      query = {}
      query[:limit] = limit if limit
      query[:after] = after if after
      query[:before] = before if before

      self.class.get(url, query: query)
    end

    # Search subreddits
    #
    # @param q [String] The search query
    # @param limit [1..100] The number of results to return
    # @param after [String] Return subreddits *after* this id.
    # @param before [String] Return subreddits *before* this id.
    # @return (see #clear_sessions)
    def search_reddits q, limit = nil, after = nil, before = nil
      raise "parameter error: limit must be within 1..100; is #{limit}" unless (1..100).include?(limit) or limit.nil?

      query = {q: q}
      query[:limit] = limit if limit
      query[:after] = after if after
      query[:before] = before if before
      self.class.get('/reddits/search.json', query: query)
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
      self.class.get("/r/#{subreddit}/about/moderators.json")
    end

    # List contributors of a subreddit
    #
    # @param (see #delete_header)
    # @param (see #clear_sessions)
    def get_contributors subreddit
      logged_in?
      self.class.get("/r/#{subreddit}/about/contributors.json")
    end

    # List banned users of a subreddit
    #
    # @param (see #delete_header)
    # @param (see #clear_sessions)
    def get_banned_users subreddit
      logged_in?
      self.class.get("/r/#{subreddit}/about/banned.json")
    end
  end
end
