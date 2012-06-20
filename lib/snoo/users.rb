module Snoo
  class Snoo
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
      self.class.get('/prefs/friends.json')
    end

    # Get info about a user account
    #
    # @param username [String] The username to target.
    def get_user_info username
      self.class.get("/user/#{username}/about.json")
    end

    # Get a listing of user posts. Some options may be restricted
    #
    # @param (see #get_user_info)
    # @param type [overview, submitted, commented, liked, disliked, hidden, saved]
    # @param sort [new, hot, top, controversial] The sort order
    # @param after [String] Return things *after* this id
    # @param before [String] Return things *before* this id
    # @param limit [1..100] Number of results to return
    # @return (see #clear_sessions)
    def get_user_listing username, type = 'overview', sort = 'new', after = nil, before = nil, limit = nil
      raise "parameter error: type must be one of overview, submitted, commented, liked, disliked, hidden, saved; is #{type}" unless %w{overview submitted commented liked disliked hidden saved}.include?(type)
      raise "parameter error: sort must be one of new, hot, top, controversial; is #{sort}" unless %w{new hot top controversial}.include?(sort)
      raise "parameter error: limit must be within 1..100; is #{limit}" unless (1..100).include?(limit) or limit.nil?
      query = {}
      query[:sort] = sort if sort != 'new'
      query[:after] = after if after
      query[:before] = before if before
      query[:limit] = limit if limit
      self.class.get("/user/%s%s.json" % [username, ('/' + type if type != overview)])
    end
  end
end
