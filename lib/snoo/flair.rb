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
      post('/api/clearflairtemplates', body: { flair_type: type, r: subreddit, uh: @modhash, api_type: 'json'})
    end

    # Deletes a user's flair
    #
    # @param user [String] The user who'se flair is affected
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_sessions)
    def delete_user_flair user, subreddit
      logged_in?
      post('/api/deleteflair', body: {name: user, r: subreddit, uh: @modhash, api_type: 'json'})
    end

    # Deletes a flair template by ID.
    #
    # @param id [String] The flair template's ID to delete.
    # @param subreddit [String] The subreddit targeted.
    def delete_flair_template id, subreddit
      logged_in?
      post('/api/deleteflairtemplate', body: {flair_template_id: id, r: subreddit, uh: @modhash, api_type: 'json'})
    end

    # Sets flair on a thing, currently supports links and users. Must specify **either** link *or* user, **not** both
    #
    # @param subreddit [String] The subreddit targeted.
    # @param opts [Hash] An options hash.
    # @option opts [String] :css_class The class(es) applied to the flair. Whitespace separated
    # @option opts [String] :text The flair text
    # @option opts [String] :name The user who we are flairing. This requires a username
    # @option opts [String] :link The thing id of the link (if a link). Begins with `t3_`
    # @return (see #clear_sessions)
    def flair subreddit, opts = {}
      logged_in?
      params = {
        r: subreddit,
        uh: @modhash,
        api_type: 'json'
      }
      params.merge! opts

      post('/api/flair', body: params)
    end

    # Configures flair options for a subreddit. All options are required
    #
    # @param subreddit [String] The subreddit targeted.
    # @param opts [Hash] An options hash
    # @option opts [true, false] :flair_enabled (true) Flair enabled?
    # @option opts [left, right] :flair_position ('right') Position of user flair.
    # @option opts [true, false] :flair_self_assign_enabled (false) Allow users to assign their own flair from templates
    # @option opts [none, left, right] :link_flair_position ('right') The position of link flair. Set to `none` to disable
    # @option opts [true, false] :link_flair_self_assign_enabled (false) Allow a submitter to assign their own link flair
    # @return (see #clear_sessions)
    def flair_config subreddit, opts = {}
      logged_in?
      options = {
        flair_enabled: true,
        flair_position: 'right',
        flair_self_assign_enabled: false,
        link_flair_position: 'right',
        link_flair_self_assign_enabled: false,
        uh: @modhash,
        r: subreddit,
        api_type: 'json'
      }
      options.merge! opts

      post('/api/flairconfig', body: options)
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
      query = {
        limit: 1000,
        uh: @modhash
      }
      query.merge! opts
      get("/r/#{subreddit}/api/flairlist.json", query: query)
    end

    # Create or edit a flair template.
    #
    # @param subreddit [String] The subreddit targeted.ate allows users to specify their own text
    # @param opts [Hash] An options hash
    # @option opts [String] css_class The list of css classes applied to this style, space separated
    # @option opts [USER_FLAIR, LINK_FLAIR] flair_type ('USER_FLAIR') The type of flair template.
    # @option opts [String] text The flair template's text.
    # @option opts [true, false] text_editable (false) If the user is allowed to edit their flair text
    # @option opts [String] template_id The flair template ID, for editing.
    # @return (see #clear_sessions)
    def flair_template subreddit, opts = {}
      logged_in?
      params = {
        flair_type: 'USER_FLAIR',
        text_editable: false,
        uh: @modhash,
        r: subreddit,
        api_type: 'json'
      }
      params.merge! opts

      post('/api/flairtemplate', body: params)
    end

    # Select a flair template and apply it to a user or link
    #
    # @param template_id [String] The template id to apply.
    # @param subreddit [String] The subreddit targeted.
    # @param (see LinksComments#info)
    # @option opts [String] :link The link id to apply to
    # @option opts [String] :user The username to apply flair to
    # @option opts [String] :text The flair text
    # @return (see #clear_sessions)
    def select_flair_template template_id, subreddit, opts = {}
      logged_in?
      params = {
        flair_template_id: template_id,
        uh: @modhash,
        r: subreddit,
        api_type: 'json'
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
      post('/api/setflairenabled', body: {flair_enabled: enabled, uh: @modhash, r: subreddit, api_type: 'json'})
    end

    # @todo implement this.
    #   it will probably require nokogiri and some trickery.
    # def flair_template_list
    # end
  end
end
