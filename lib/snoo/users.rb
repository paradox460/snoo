module Snoo
  # Methods for interacting with users, such as adding and removing friends, getting user info, etc
  #
  # @author (see Snoo)
  module User

    # Friend a user
    #
    # @param name [String] The username to target
    # @param note [String] A friend tag. Requires reddit gold.
    # @return (see #clear_sessions)
    def friend name, friend_id, note = nil
      friend_wrapper(api_name = name, api_container = @userid, api_note = note, api_type = "friend")
    end

    # Unfriend a user
    #
    # @param id [String] The friend id to remove. Must be in t2_id form
    # @return (see #clear_sessions)
    def unfriend id
      unfriend_wrapper api_id = id, api_container = @userid, api_type = "friend"
    end

    # Get a list of friends
    #
    # @return (see #clear_sessions)
    def get_friends
      logged_in?
      get('/prefs/friends.json')
    end

    # Get info about a user account
    #
    # @param username [String] The username to target.
    def get_user_info username
      get("/user/#{username}/about.json")
    end

    # Get a listing of user posts. Some options may be restricted
    #
    # @param (see #get_user_info)
    # @param (see LinksComments#info)
    # @option opts [overview, submitted, comments, liked, disliked, hidden, saved] :type Type of post to return. Most users only allow the first 3 types.
    # @option opts [new, hot, top, controversial] :sort The sort order
    # @option opts [String] :after Return things *after* this id
    # @option opts [String] :before Return things *before* this id
    # @option opts [1..100] :limit Number of results to return
    # @return (see #clear_sessions)
    def get_user_listing username, opts = {}
      opts[:type] = 'overview' if opts[:type].nil?
      url = "/user/%s%s.json" % [username, ('/' + opts[:type] if opts[:type] != 'overview')]
      opts.delete :type
      query = opts
      get(url, query: query)
    end
  end
end
