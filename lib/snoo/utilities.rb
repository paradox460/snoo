module Snoo
  class Snoo

    private
      # Set the cookie header and instance variable
      #
      # @param cookie [String] The cookie text, as show in a 'set-cookie' header
      def setCookies cookie
        @cookies = cookie
        headers 'Cookie' => cookie
      end

      # Raises an error if we aren't currently logged in
      #
      def logged_in?
        raise "not logged in" if @modhash.nil? && @modhash.nil?
      end
  end
end
