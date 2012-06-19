module Snoo
  class Snoo

    # Clear all the flair templates of a particular type
    # 
    # @param type [String] The type of template to clear. One of `USER_FLAIR` or `LINK_FLAIR`
    # @param subreddit [String] The subreddit targeted.
    # @return [HTTParty::request] The request object
    def clear_flair_templates type, subreddit
      logged_in?
      self.class.post('/api/clearflairtemplates', body: { flair_type: type, r: subreddit, uh: @modhash})
    end

    # Deletes a user's flair
    # 
    # @param user [String] The user who'se flair is affected
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_flair_templates)
    def delete_user_flair user, subreddit
      logged_in?
      self.class.post('/api/deleteflair', body: {name: user, r: subreddit, uh: @modhash})
    end

    # Deletes a flair template by ID.
    # 
    # @param id [String] The flair template's ID to delete. Get this from {#flair_template_list}
    # @param subreddit [String] The subreddit targeted.
    def delete_flair_template id, subreddit
      logged_in?
      self.class.post('/api/deleteflairtemplate', body: {flair_template_id: id, r: subreddit, uh: @modhash})
    end

    # Sets flair on a thing, currently supports links and users. Must specify *either* link *or* user, *not* both
    # 
    # @param css_class [String] The class(es) applied to the flair. Whitespace separated
    # @param link [String] The thing id of the link (if a link). Begins with `t3_`
    # @param name [String] The user who we are flairing. This requires a username.
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_flair_templates)
    def flair css_class, link = nil, name = nil, text, subreddit
      logged_in?
      raise "parameter error: either link or name, not both" if link && name
      params = {
        css_class: css_class,
        text: text,
        r: subreddit,
        uh: @modhash
      }
      params[:link] = link if link
      params[:name] = name if name

      self.class.post('/api/flair', body: params)
    end

    # Configures flair options for a subreddit. All options are required
    # 
    # @params enabled [true, false] Flair enabled?
    # @params position [left, right] Position of user flair.
    # @params self_assign [true, false] Allow users to assign their own flair from templates
    # @params link_position [none, left, right] The position of link flair. Set to `none` to disable
    # @params link_assign [true, false] Allow a submitter to assign their own link flair
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_flair_templates)
    def flair_config enabled, position, self_assign, link_position, link_assign, subreddit
      logged_in?
      # Test the params
      tests = [true, false]
      raise "parameter error" unless tests.include?(enabled) && tests.include?(self_assign) && tests.include?(link_assign)
      tests << "none"
      raise "parameter error" unless tests.include?(link_position)

      self.class.post('/api/flairconfig', body: {
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
    # @params csv [String] A string, in CSV format, of `user,flair-text,css_class` per line, with no more than 100 flairs, and **no header line**.
    # @param subreddit [String] The subreddit targeted.
    # @return [HTTParty::request] The request object. Note that this request object contains a json confirming the status of each line of the CSV
    def flair_csv csv, subreddit
      self.class.post('/api/flaircsv.json', body: {flair_csv: csv, r: subreddit, uh: @modhash})
    end

    # Downloads flair from the subreddit
    # This is limited to 1000 per request, use before/after to get "pages"
    # 
    # @param limit [Fixnum] The amount of flairs to get. Must be between 1 and 1000
    # @param before [String] Return entries just before this user id
    # @param after [String] Return entries just after this user id
    # @param subreddit [String] The subreddit targeted.
    # @return (see #clear_flair_templates)
    def get_flair_list limit = 1000, before = nil, after = nil, subreddit
      raise 'parameter error: limit is too high/low' unless (1..1000).include?(limit)
      query = {
        r: subreddit,
        limit: limit,
        uh: @modhash
      }
      query[:before] = before if before
      query[:after] = after if after
      self.class.get('/api/flairlist.json', query: query)
    end

    

    # @todo implement this.
    #   it will probably require nokogiri and some trickery.
    def flair_template_list
    end
  end
end
