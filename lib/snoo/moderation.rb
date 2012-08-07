module Snoo
  # Methods for moderating on reddit, including tasks such as removing, approving, and distinguishing
  #
  # @author (see Snoo)
  module Moderation

    # Approve a thing
    #
    # @param id [String] Thing targeted
    # @return (see #clear_sessions)
    def approve id
      logged_in?
      post('/api/approve', body: {id: id, uh: @modhash})
    end

    # Distinguish a thing
    #
    # @param (see #approve)
    # @param how [yes, no, admin, special] Determines how to distinguish something. Only works for the permissions you have.
    # @return (see #clear_sessions)
    def distinguish id, how
      logged_in?
      hows = %w{yes no admin special}
      raise ArgumentError, "how should be one of #{hows * ', '}, is #{how}" if hows.include?(how)
      post('/api/distinguish', body: {id: id, how: how, uh: @modhash})
    end

    # Removes you from a subreddits list of contributors
    # @note (see #clear_sessions)
    #
    # @param id [String] The subreddit id
    # @return (see #clear_sessions)
    def leave_contributor id
      logged_in?
      post('/api/leavecontributor', body: {id: id, uh: @modhash})
    end

    # Removes you from a subreddits moderators
    # @note (see #clear_sessions)
    #
    # @param (see #leave_contributor)
    # @return (see #clear_sessions)
    def leave_moderator id
      logged_in?
      post('/api/leavemoderator', body: {id: id, uh: @modhash})
    end

    # Removes a thing
    #
    # @param (see #approve)
    # @param spam [true, false] Mark this removal as a spam removal (and train the spamfilter)
    # @return (see #clear_sessions)
    def remove id, spam
      logged_in?
      spams = [true, false]
      raise ArgumentError, "spam should be boolean, is #{spam}" unless spams.include?(spam)
      post('/api/remove', body: {id: id, spam: spam, uh: @modhash})
    end

    # Gets a moderation log
    # This is a tricky function, and may break a lot.
    # Blame the lack of a real api
    #
    # @param subreddit [String] The subreddit to fetch from
    # @param opts [Hash] Options to pass to reddit
    # @option opts [Fixnum] :count (100) The number to get. Can't be higher than 100
    # @option opts [String] :before The "fullname" to fetch before.
    # @option opts [String] :after The "fullname" to fetch after.
    # @option opts [String] :type See [reddit API docs](http://www.reddit.com/dev/api#GET_moderationlog)
    # @option opts [String] :mod The moderator to get. Name, not ID
    # @return [Hash] A hash consisting of the data, first fullname, last fullname, first date, and last date
    def modlog subreddit, opts = {}
      logged_in?
      options = {
        count: 100
      }.merge opts
      data = Nokogiri::HTML.parse(get("/r/#{subreddit}/about/log", query: options).body).css('.modactionlisting tr')
      processed = {
        data:       [],
        first:      data[0]['data-fullname'],
        first_date: Time.parse(data[0].children[0].child['datetime']),
        last:       data[-1]['data-fullname'],
        last_date:  Time.parse(data[-1].children[0].child['datetime'])
      }
      data.each do |tr|

        processed[:data] << {
          fullname:     tr['data-fullname'],
          time:         Time.parse(tr.children[0].child['datetime']),
          author:       tr.children[1].child.content,
          action:       tr.children[2].child['class'].split[1],
          description:  tr.children[3].content
        }
      end
        return processed
    end

  end
end
