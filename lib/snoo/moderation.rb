module Snoo
  class Snoo
    # @!group Moderation

    # Approve a thing
    #
    # @param id [String] Thing targeted
    # @return (see #clear_sessions)
    def approve id
      logged_in?
      self.class.post('/api/approve', body: {id: id, uh: @modhash})
    end

    # Distinguish a thing
    #
    # @param (see #approve)
    # @param how [yes, no, admin, special] Determines how to distinguish something. Only works for the permissions you have.
    # @return (see #clear_sessions)
    def distinguish id, how
      logged_in?
      hows = %w{yes no admin special}
      raise "parameter error: how should be one of #{hows * ', '}, is #{how}" if hows.include?(how)
      self.class.post('/api/distinguish', body: {id: id, how: how, uh: @modhash})
    end

    # Removes you from a subreddits list of contributors
    # @note (see #clear_sessions)
    #
    # @param id [String] The subreddit id
    # @return (see #clear_sessions)
    def leave_contributor id
      logged_in?
      self.class.post('/api/leavecontributor', body: {id: id, uh: @modhash})
    end

    # Removes you from a subreddits moderators
    # @note (see #clear_sessions)
    #
    # @param (see #leave_contributor)
    # @return (see #clear_sessions)
    def leave_moderator id
      logged_in?
      self.class.post('/api/leavemoderator', body: {id: id, uh: @modhash})
    end

    # Removes a thing
    #
    # @param (see #approve)
    # @param spam [true, false] Mark this removal as a spam removal (and train the spamfilter)
    # @return (see #clear_sessions)
    def remove id, spam
      logged_in?
      spams = [true, false]
      raise "parameter error: spam should be boolean, is #{spam}" unless spams.include?(spam)
      self.class.post('/api/remove', body: {id: id, spam: spam, uh: @modhash})
    end

  end
end
