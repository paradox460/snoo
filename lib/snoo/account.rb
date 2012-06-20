module Snoo
  class Snoo
    # @!group Account

    # Log into a reddit account. You need to do this to use any restricted or write APIs
    #
    # @param username [String] The reddit account's username you wish to log in as
    # @param password [String] The password of the reddit account
    def log_in username, password
      login = self.class.post("/api/login", :body => {user: username, passwd: password, api_type: 'json'})
      errors = login['json']['errors']
      raise errors[0][1] unless errors.size == 0
      cookies login.headers['set-cookie']
      @modhash = login['json']['data']['modhash']
      @username = username
      @userid = 't2_' + self.class.post('/api/me.json')['data']['id']
    end

    # Logs out of a reddit account. This is usually uneeded, you can just log_in as a new account to replace the current one.
    # This just nils the cookies and modhash
    def log_out
      cookies nil
      @modhash = nil
      @userid = nil
    end

    # Invalidates all other reddit session cookies, and updates the current one.
    # This will log out all other reddit clients, as described in the [reddit API](http://www.reddit.com/dev/api#POST_api_clear_sessions)
    #
    # @note This method provides no verification or checking, so use with care
    # @param password [String] The password of the reddit account
    # @return [HTTParty::Response] The httparty request object.
    def clear_sessions password
      logged_in?
      clear = self.class.post('/api/clear_sessions', body: { curpass: password, dest: @baseurl, uh: @modhash })
      cookies clear.headers['set-cookie']
      return clear
    end

    # Deletes the current user. This requires a password for security reasons.
    #
    # @note (see #clear_sessions)
    # @param password [String] The password for the current user
    # @param reason [String] The reason the current user account is being deleted.
    # @return (see #clear_sessions)
    def delete_user password, reason = "deleted by script command"
      logged_in?
      delete = self.class.post('/api/delete_user', body: {
        confirm: true,
        delete_message: reason,
        passwd: password,
        uh: @modhash,
        user: @username
        })
      return delete
    end

    # Gets info about the currently logged in user.
    # @return [Hash] Parsed JSON from reddit
    def me
      logged_in?
      self.class.get("/api/me.json").body
    end

    # Changes the current user's password/email.
    #
    # @note (see #clear_sessions)
    # @param currentPass [String] The current password
    # @param email [String] The email address you would like to update to. Optional
    # @param newPass [String] The new password
    # @return (see #clear_sessions)
    def update_user currentPass, email = nil, newPass
      logged_in?
      params = {
        curpass: currentPass,
        newpass: newPass,
        uh: @modhash,
        verify: true,
        verpass: newPass
        }
      params[:email] = email if email
      update = self.class.post('/api/update', body: params )
      cookies update.headers['set-cookie']
      return update
    end
  end
end
