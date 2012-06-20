module Snoo
  # Methods for interacting with private messages
  #
  # @author (see Snoo)
  module PM

    # Block a user from sending you messages
    #
    # @param id [String] the user id.
    # @return (see #clear_sessions)
    def block_pm id
      logged_in?
      self.class.post('/api/block', body: {id: id, uh: @modhash})
    end

    # Send a private message
    # To reply to PM, use {#comment}, with the PM id as the link id
    #
    # @param to [String] The username you are sending to
    # @param subject [String] The subject of the message
    # @param text [String] The message body
    # @return (see #clear_sessions)
    def send_pm to, subject, text
      logged_in?
      self.class.post('/api/compose.json', body: {to: to, subject: subject, text: text, uh: @modhash})
    end

    # Mark a PM as read
    #
    # @param id [String] The message id
    # @return (see #clear_sessions)
    def mark_read id
      logged_in?
      self.class.post('/api/read_message', body: {id: id, uh: @modhash})
    end

    # Mark a PM as unread
    #
    # @param (see #mark_read)
    # @return (see #clear_sessions)
    def mark_unread id
      logged_in?
      self.class.post('/api/unread_message', body: {id: id, uh: @modhash})
    end

    # Gets a listing of PMs
    #
    # @param where [inbox, unread, sent] Where to get messages from
    # @param mark [true, false] Mark the messages requested as read?
    # @param limit [1..100] The total number of messages to get
    # @param before [String] Get all comments *before* this id
    # @param after [String] Get all comments *after* this
    # @return (see #clear_sessions)
    def get_messages where, mark = false, limit = nil, before = nil, after = nil
      bools = [true, false]
      wheres = %w{inbox unread sent}
      raise "parameter error: where must be #{wheres * ', '}, is #{where}" unless wheres.include?(where)
      raise "parameter error: mark must be boolean, is #{mark}" unless bools.include?(mark)
      raise "parameter error: limit must be 1..100, is #{limit}" unless (1..100).include?(limit) or limit.nil?

      query = {}
      query[:mark] = mark if mark
      query[:limit] = limit if limit
      query[:before] = before if before
      query[:after] = after if after
      self.class.get("/message/#{where}.json", query: query)
    end
  end
end
