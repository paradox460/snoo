module Snoo
  # Utility functions.
  #
  # @author (see Snoo)
  module Utilities

    # Set the cookie header and instance variable
    #
    # @param cookie [String] The cookie text, as show in a 'set-cookie' header
    def set_cookies cookie
      @cookies = cookie
      self.class.headers 'Cookie' => cookie
    end

    private
      # HTTParty get wrapper. This serves to clean up code, as well as throw webserver errors wherever needed
      #
      def get *args, &block
        response = self.class.get *args, &block
        raise WebserverError, response.code unless response.code == 200
        response
      end

      # HTTParty POST wrapper. This serves to clean up code, as well as throw webserver errors wherever needed, same as {#get}
      #
      def post *args, &block
        response = self.class.post *args, &block
        raise WebserverError, response.code unless response.code == 200
        response
      end

      # Raises an error if we aren't currently logged in
      #
      def logged_in?
        raise NotAuthenticated if @cookies.nil? or @modhash.nil?
      end

      # Posts to '/api/friend'. This method exists because there are tons of things that use this
      # See http://www.reddit.com/dev/api#POST_api_friend for details
      #
      # @param opts [Hash] an options hash
      # @option opts [String] :type The type of action to add.
      # @option opts [String] :container The id of the containing user/object/thing
      # @option opt [String] :note The reddit gold user node
      # @option opts [String] :name The name of a reddit user
      # @return [HTTParty::Response] The response object.
      def friend_wrapper opts = {}
        logged_in?
        params = {uh: @modhash, api_type: 'json'}
        params.merge! opts
        post('/api/friend', body: params)
      end

      # Posts to '/api/unfriend'. This method exists because there are a ton of things that use this.
      #
      # @param opts [Hash] an options hash
      # @option opts [String] :type The type of action to add.
      # @option opts [String] :container The id of the containing user/object/thing
      # @option opts [String] :name The name of a reddit user
      # @return (see #friend_wrapper)
      def unfriend_wrapper opts = {}
        logged_in?
        params = { uh: @modhash, api_type: 'json'}
        params.merge! opts
        post('/api/unfriend', body: params)
      end
  end
end
