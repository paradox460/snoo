module Snoo
  # Not Authenticated exception. Thrown whenever a user is not logged into reddit and they should be
  #
  # @author (see Snoo)
  class NotAuthenticated < StandardError
  end

  # Thrown whenever the webserver returns anyting but 200
  #
  # @author (see Snoo)
  class WebserverError < StandardError
  end
end
