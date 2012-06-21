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
      post('/api/block', body: {id: id, uh: @modhash})
    end

    # Send a private message
    # To reply to PM, use {LinksComments#comment}, with the PM id as the link id
    #
    # @param to [String] The username you are sending to
    # @param subject [String] The subject of the message
    # @param text [String] The message body
    # @return (see #clear_sessions)
    def send_pm to, subject, text
      logged_in?
      post('/api/compose.json', body: {to: to, subject: subject, text: text, uh: @modhash})
    end

    # Mark a PM as read
    #
    # @param id [String] The message id
    # @return (see #clear_sessions)
    def mark_read id
      logged_in?
      post('/api/read_message', body: {id: id, uh: @modhash})
    end

    # Mark a PM as unread
    #
    # @param (see #mark_read)
    # @return (see #clear_sessions)
    def mark_unread id
      logged_in?
      post('/api/unread_message', body: {id: id, uh: @modhash})
    end

    # Gets a listing of PMs
    #
    # @param where [inbox, unread, sent] Where to get messages from
    # @param (see LinksComments#info)
    # @option opts [true, false] :mark (false) Mark the messages requested as read?
    # @option opts [1..100] :limit The total number of messages to get
    # @option opts [String] :before Get all comments *before* this id
    # @option opts [String] :after Get all comments *after* this
    # @return (see #clear_sessions)
    def get_messages where = "inbox", opts = {},
      bools = [true, false]
      wheres = %w{inbox unread sent}
      raise ArgumentError, "where must be #{wheres * ', '}, is #{where}" unless wheres.include?(where)
      raise ArgumentError, "mark must be boolean, is #{opts[:mark]}" unless bools.include?(opts[:mark]) or opts[:mark].nil?
      raise ArgumentError, "limit must be 1..100, is #{opts[:limit]}" unless (1..100).include?(opts[:limit]) or opts[:limit].nil?

      query = {
        mark: false
      }
      query.merge! opts
      get("/message/#{where}.json", query: query)
    end
  end
end
