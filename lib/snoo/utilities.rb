module Snoo
  # Utility functions.
  # These are all private
  #
  # @author (see Snoo)
  module Utilities
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
      # Set the cookie header and instance variable
      #
      # @param cookie [String] The cookie text, as show in a 'set-cookie' header
      def set_cookies cookie
        @cookies = cookie
        self.class.headers 'Cookie' => cookie
      end

      # Raises an error if we aren't currently logged in
      #
      def logged_in?
        raise NotAuthenticated if @cookies.nil? or @modhash.nil?
      end

      # Posts to '/api/friend'. This method exists because there are tons of things that use this
      #
      # @param api_type [friend, moderator, contributor, banned] Type of action to use. All but friend target subreddits
      # @param api_container [String] Thing ID, either subreddit (t5_) or user adding friend (t2_)
      # @param api_name [String] Username to add
      # @param api_note [String] Note to leave. Requires reddit gold
      # @param api_subreddit [String] Subreddit name
      # @return [HTTParty::Response] The response object.
      def friend_wrapper api_type, api_container = nil, api_name = nil, api_note = nil, api_subreddit = nil
        logged_in?
        params = {type: api_type, uh: @modhash}
        params[:container] = api_container if api_container
        params[:name] = api_name if api_name
        params[:note] = api_note if api_note
        params[:r] = api_subreddit if api_subreddit
        post('/api/friend', body: params)
      end

      # Posts to '/api/unfriend'. This method exists because there are a ton of things that use this.
      #
      # @param api_type [friend, enemy, moderator, contributor, banned] Type of removal
      # @param api_container [String] Thing ID, either subreddit (t5_) or user adding friend (t2_)
      # @param api_name [String] User name
      # @param api_id [String] User ID of user being removed
      # @param api_subreddit [String] Subreddit name
      # @return (see #friend_wrapper)
      def unfriend_wrapper api_type, api_container = nil, api_name = nil, api_id = nil, api_subreddit = nil
        logged_in?
        params = { type: api_type, uh: @modhash}
        params[:container] = api_container if api_container
        params[:name] = api_name if api_name
        params[:id] = api_id if api_id
        params[:r] = api_subreddit if api_subreddit
        post('/api/unfriend', body: params)
      end
  end
end
