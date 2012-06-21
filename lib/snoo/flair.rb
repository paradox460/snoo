module Snoo
  # Flair related methods.
  # These are used for interacting with flair in reddit. Things like giving flair, setting templates, and whatnot.
  #
  # @author (see Snoo)
  module Flair

    # Clear all the flair templates of a particular type
    #
    # @param type [USER_FLAIR, LINK_FLAIR] The type of template to clear.
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_sessions)
    def clear_flair_templates type, subreddit
      logged_in?
      tests = ['USER_FLAIR', 'LINK_FLAIR']
      raise ArgumentError, 'type needs to be either USER_FLAIR or LINK_FLAIR' unless tests.include?(type)
      post('/api/clearflairtemplates', body: { flair_type: type, r: subreddit, uh: @modhash})
    end

    # Deletes a user's flair
    #
    # @param user [String] The user who'se flair is affected
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_sessions)
    def delete_user_flair user, subreddit
      logged_in?
      post('/api/deleteflair', body: {name: user, r: subreddit, uh: @modhash})
    end

    # Deletes a flair template by ID.
    #
    # @param id [String] The flair template's ID to delete. Get this from {#flair_template_list}
    # @param subreddit [String] The subreddit targeted.
    def delete_flair_template id, subreddit
      logged_in?
      post('/api/deleteflairtemplate', body: {flair_template_id: id, r: subreddit, uh: @modhash})
    end

    # Sets flair on a thing, currently supports links and users. Must specify **either** link *or* user, **not** both
    #
    # @param subreddit [String] The subreddit targeted.
    # @param opts [Hash] An options hash.
    # @option opts [String] :css_class The class(es) applied to the flair. Whitespace separated
    # @option opts [String] :text The flair text
    # @option opts [String] :name The user who we are flairing. This requires a username.r
    # @option opts [String] :link The thing id of the link (if a link). Begins with `t3_`
    # @return (see #clear_sessions)
    def flair subreddit, opts = {}
      logged_in?
      raise ArgumentError, "link or name, not both" if opts[:link] && opts[:name]
      params = {
        r: subreddit,
        uh: @modhash,
      }
      params.merge! opts

      post('/api/flair', body: params)
    end

    # Configures flair options for a subreddit. All options are required
    #
    # @param enabled [true, false] Flair enabled?
    # @param position [left, right] Position of user flair.
    # @param self_assign [true, false] Allow users to assign their own flair from templates
    # @param link_position [none, left, right] The position of link flair. Set to `none` to disable
    # @param link_assign [true, false] Allow a submitter to assign their own link flair
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_sessions)
    def flair_config enabled, position, self_assign, link_position, link_assign, subreddit
      logged_in?
      # Test the params
      tests = [true, false]
      raise "parameter error" unless tests.include?(enabled) && tests.include?(self_assign) && tests.include?(link_assign)
      tests << "none"
      raise "parameter error" unless tests.include?(link_position)

      post('/api/flairconfig', body: {
        flair_enabled: enabled,
        flair_position: position,
        flair_self_assign_enabled: self_assign,
        link_flair_position: link_position,
        link_flair_self_assign_enabled: link_assign,
        uh: @modhash,
        r: subreddit
        })
    end

    # Post flair in a CSV file to reddit
    #
    # @param csv [String] A string, in CSV format, of `user,flair-text,css_class` per line, with no more than 100 flairs, and **no header line**.
    # @param subreddit [String] The subreddit targeted.
    # @return [HTTParty::Response] The request object. Note that this request object contains a json confirming the status of each line of the CSV
    def flair_csv csv, subreddit
      logged_in?
      post('/api/flaircsv.json', body: {flair_csv: csv, r: subreddit, uh: @modhash})
    end

    # Downloads flair from the subreddit
    # This is limited to 1000 per request, use before/after to get "pages"
    #
    # @param (see #flair)
    # @option opts [Fixnum] :limit (1000) The amount of flairs to get. Must be between 1 and 1000
    # @option opts [String] :before Return entries just before this user id
    # @option opts [String] :after Return entries just after this user id
    # @return (see #clear_sessions)
    def get_flair_list subreddit, opts = {}
      logged_in?
      raise ArgumentError, 'limit is too high/low' unless (1..1000).include?(opts[:limit])
      query = {
        limit: 1000,
        uh: @modhash
      }
      query.merge! opts
      get("/r/#{subreddit}/api/flairlist.json", query: query)
    end

    # Create or edit a flair template.
    #
    # @param css_class [String] The list of css classes applied to this style, space separated
    # @param type [USER_FLAIR, LINK_FLAIR] The type of flair template.
    # @param text [String] The flair template's text.
    # @param user_editable [true, false] If the templ
    # @param subreddit [String] The subreddit targeted.ate allows users to specify their own text
    # @param template_id [String] The flair template ID, for editing. Get this from {#flair_template_list}
    # @return (see #clear_sessions)
    def flair_template css_class, type, text, user_editable, subreddit, template_id = nil
      logged_in?
      test = ['USER_FLAIR', 'LINK_FLAIR']
      raise ArgumentError, 'type is either USER_FLAIR or LINK_FLAIR' unless test.include?(type)
      test = [true, false]
      raise ArgumentError, 'user_editable needs to be true or false' unless test.include?(user_editable)

      params = {
        css_class: css_class,
        flair_type: type,
        text: text,
        text_editable: user_editable,
        uh: @modhash,
        r: subreddit
      }
      params[:flair_template_id] = template_id if template_id
      post('/api/flairtemplate', body: params)
    end

    # Select a flair template and apply it to a user or link
    #
    # @param template_id [String] The template id to apply. Get this from {#flair_template_list}
    # @param text [String] The flair text
    # @param subreddit [String] The subreddit targeted.
    # @param (see LinksComments#info)
    # @option opts [String] :link The link id to apply to
    # @option opts [String] :user The username to apply flair to
    # @return (see #clear_sessions)
    def select_flair_template template_id, text, subreddit, opts = {}
      logged_in?
      raise ArgumentError, 'link or user, not both' if link && user
      params = {
        flair_template_id: template_id,
        text: text,
        uh: @modhash,
        r: subreddit
      }
      params.merge! opts
      post('/api/selectflair', body: params)
    end

    # Toggle flair on and off for a subreddit
    #
    # @param enabled [true, false] Enable/disable flair
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_sessions)
    def flair_toggle enabled, subreddit
      logged_in?
      test = [true, false]
      raise ArgumentError, 'enabled must be boolean' unless test.include?(enabled)
      post('/api/setflairenabled', body: {flair_enabled: enabled, uh: @modhash, r: subreddit})
    end

    # @todo implement this.
    #   it will probably require nokogiri and some trickery.
    def flair_template_list
    end
  end
end
