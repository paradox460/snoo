module Snoo
  # rubocop:disable Metrics/ClassLength
  class Client < Support::BaseClient
    base_url 'https://www.reddit.com'

    # Accounts
    consume '/api/v1/me', as: :me
    consume '/api/v1/me/blocked',
            as: :blocked,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/api/v1/me/friends',
            as: :friends,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/api/v1/me/karma', as: :karma
    consume '/api/v1/me/prefs', as: :prefs
    consume '/api/v1/me/prefs',
            as: :update_prefs,
         using: :patch
    consume '/api/v1/me/trophies', as: :my_trophies

    # Captcha
    consume '/api/needs_captcha',
            as: :needs_captcha?
    consume '/api/new_captcha',
            as: :new_captcha,
         using: :post
    consume '/captcha/:iden',
            as: :captcha

    # Flair
    # TODO: Non-user facing params with values (in this case, api_type: json)
    consume '/r/:subreddit/api/clearflairtemplates',
            as: :clear_flair_templates,
         using: :post
    consume '/r/:subreddit/api/deleteflair',
            as: :delete_flair,
         using: :post
    consume '/r/:subreddit/api/deleteflairtemplate',
            as: :delete_flair_template,
         using: :post
    consume '/r/:subreddit/api/flair',
            as: :flair,
         using: :post
    consume '/r/:subreddit/api/flairconfig',
            as: :flair_config,
         using: :post
    consume '/r/:subreddit/api/flaircsv',
            as: :flair_csv,
         using: :post
    consume '/r/:subreddit/api/flairlist',
            as: :flairs,
        params: { optional: %i(after before count limit name show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/api/flairselector',
            as: :flair_selector,
         using: :post
    consume '/r/:subreddit/api/flairtemplate',
            as: :flair_template,
         using: :post
    consume '/r/:subreddit/api/selectflair',
            as: :select_flair,
         using: :post
    consume '/r/:subreddit/api/setflairenabled',
            as: :toggle_flair,
         using: :post

    # reddit gold
    consume '/api/v1/gold/gild/:fullname',
            as: :guild,
         using: :post
    consume '/api/v1/gold/give/:username',
            as: :give_gold,
         using: :post
    # Links & Comments
    consume '/api/comment',
            as: :comment,
         using: :post
    consume '/api/del',
            as: :delete,
         using: :post
    consume '/api/editusertext',
            as: :edit_user_text,
         using: :post
    consume '/api/hide',
            as: :hide,
         using: :post
    consume '/r/:subreddit/api/info',
            as: :info,
        params: { required: %i(id url) }
    consume '/api/lock',
            as: :lock,
         using: :post
    consume '/api/marknsfw',
            as: :mark_nsfw,
         using: :post
    consume '/api/morechildren',
            as: :more_children,
        params: { required: %i(children link_id), optional: %i(id sort) }
    consume '/api/report',
            as: :report,
         using: :post
    consume '/api/save',
            as: :save,
         using: :post
    consume '/api/saved_categories',
            as: :saved_categories
    consume '/api/sendreplies',
            as: :send_replies,
         using: :post
    consume '/api/set_contest_mode',
            as: :set_contest_mode,
         using: :post
    consume '/api/set_subreddit_sticky',
            as: :set_subreddit_sticky,
         using: :post
    consume '/api/set_suggested_sort',
            as: :set_suggested_sort,
         using: :post
    consume '/api/store_visits',
            as: :store_visits,
         using: :post
    consume '/api/submit',
            as: :submit,
         using: :post
    consume '/api/unhide',
            as: :unhide,
         using: :post
    consume '/api/unlock',
            as: :unlock,
         using: :post
    consume '/api/unmarknsfw',
            as: :unmark_nsfw,
         using: :post
    consume '/api/unsave',
            as: :unsave,
         using: :post
    consume '/api/vote',
            as: :vote,
         using: :post
    # Listings
    consume '/by_id/:names', as: :by_id
    consume '/r/:subreddit/comments/:article',
            as: :comments,
        params: { optional: %i(comment context depth limit showedits showmore sort sr_detail) }
    consume '/duplicates/:article',
            as: :duplicates,
        params: { optional: %i(after before count limit name show sr_detail) } # TODO: Genericize into listing type
    consume 'related/:article',
            as: :related
    consume '/r/:subreddit/hot',
            as: :hot,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/new',
            as: :new_posts,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/random',
            as: :random,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/top',
            as: :top,
        params: { optional: %i(t after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/controversial',
            as: :controversial,
        params: { optional: %i(t after before count limit show sr_detail) } # TODO: Genericize into listing type
    # live threads
    consume '/api/live/create',
            as: :new_live_thread,
         using: :post
    consume '/api/live/:thread/accept_contributor_invite',
            as: :accept_live_thread_invite,
         using: :post
    consume '/api/live/:thread/close_thread',
            as: :close_live_thread,
         using: :post
    consume '/api/live/:thread/delete_update',
            as: :delete_live_thread_update,
         using: :post
    consume '/api/live/:thread/edit',
            as: :edit_live_thread,
         using: :post
    consume '/api/live/:thread/invite_contributor',
            as: :live_thread_invite,
         using: :post
    consume '/api/live/:thread/leave_contributor',
            as: :live_thread_leave,
         using: :post
    consume '/api/live/:thread/report',
            as: :live_thread_report,
         using: :post
    consume '/api/live/:thread/rm_contributor',
            as: :live_thread_remove_contributor,
         using: :post
    consume '/api/live/:thread/rm_contributor_invite',
            as: :live_thread_remove_contributor_invite,
         using: :post
    consume '/api/live/:thread/set_contributor_permissions',
            as: :live_thread_contributor_permissions,
         using: :post
    consume '/api/live/:thread/strike_update',
            as: :live_thread_strike_update,
         using: :post
    consume '/api/live/:thread/update',
            as: :live_thread_update,
         using: :post
    consume '/live/:thread',
            as: :live_thread
    consume '/live/:thread/about',
            as: :live_thread_about
    consume '/live/:thread/contributors',
            as: :live_thread_contributors
    consume '/live/:thread/discussions',
            as: :live_thread_discussions
    # private messages
    consume '/api/block',
            as: :block,
         using: :post
    consume '/api/collapse_message',
            as: :collapse_message,
         using: :post
    consume '/api/compose',
            as: :compose,
         using: :post
    consume '/api/read_all_messages',
            as: :read_all_messages,
         using: :post
    consume '/api/read_message',
            as: :read_message,
         using: :post
    consume '/api/unblock_subreddit',
            as: :unblock_subreddit,
         using: :post
    consume '/api/uncollapse_message',
            as: :uncollapse_message,
         using: :post
    consume '/api/unread_message',
            as: :unread_message,
         using: :post
    consume '/message/inbox',
            as: :inbox,
        params: { optional: %i(mark mid after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/message/sent',
            as: :sent,
        params: { optional: %i(mark mid after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/message/unread',
            as: :unread,
        params: { optional: %i(mark mid after before count limit show sr_detail) } # TODO: Genericize into listing type
    # misc
    consume '/api/v1/scopes',
            as: :scopes,
        params: { optional: :scopes }
    # moderation
    consume '/r/:subreddit/about/log',
            as: :modlog,
        params: { optional: %i(after before count limit mod show sr_detail type) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/edited',
            as: :edited,
        params: { optional: %i(after before count limit location only show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/modqueue',
            as: :modqueue,
        params: { optional: %i(after before count limit location only show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/reports',
            as: :reports,
        params: { optional: %i(after before count limit location only show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/spam',
            as: :spam,
        params: { optional: %i(after before count limit location only show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/unmoderated',
            as: :unmoderated,
        params: { optional: %i(after before count limit location only show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/api/accept_moderator_invite',
            as: :accept_moderator_invite,
         using: :post
    consume '/r/:subreddit/api/approve',
            as: :approve,
         using: :post
    consume '/r/:subreddit/api/distinguish',
            as: :distinguish,
         using: :post
    consume '/r/:subreddit/api/ignore_reports',
            as: :ignore_reports,
         using: :post
    consume '/r/:subreddit/api/leavecontributor',
            as: :leave_contributor,
         using: :post
    consume '/r/:subreddit/api/leavemoderator',
            as: :leave_moderator,
         using: :post
    consume '/r/:subreddit/api/mute_message_author',
            as: :mute_message_author,
         using: :post
    consume '/r/:subreddit/api/remove',
            as: :remove,
         using: :post
    consume '/r/:subreddit/api/unignore_reports',
            as: :unignore_reports,
         using: :post
    consume '/r/:subreddit/api/unmute_message_author',
            as: :unmute_message_author,
         using: :post
    # multis
    consume '/api/multi/mine',
            as: :my_multis
    consume '/api/multi/user/:username',
            as: :user_multis
    consume '/api/multi/:multipath/description',
            as: :multi_description
    consume '/api/multi/:multipath/description',
            as: :update_multi_description,
         using: :put
    consume '/api/multi/:multipath/r/:srname',
            as: :multi_subreddit_info
    consume '/api/multi/:multipath/r/:srname',
            as: :delete_subreddit_from_multi,
         using: :delete
    consume '/api/multi/:multipath/r/:srname',
            as: :add_subreddit_to_multi,
         using: :put
    consume '/api/multi/:multipath',
            as: :multi,
        params: { optional: :expand_srs }
    consume '/api/multi/:multipath',
            as: :new_multi,
         using: :post
    consume '/api/multi/:multipath',
            as: :update_multi,
         using: :put
    consume '/api/multi/:multipath',
            as: :delete_multi,
         using: :delete
    consume '/api/multi/copy',
            as: :copy_multi,
         using: :post
    consume '/api/multi/rename',
            as: :rename_multi,
         using: :post
    # search
    consume '/r/:subreddit/search',
            as: :search,
        params: { required: :q, optional: %i(after before count include_facets limit restrict_sr show sort sr_detail syntax t type) } # TODO: Genericize into listing type
    # subreddits
    consume '/r/:subreddit/about/banned',
            as: :banned,
        params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/contributors',
            as: :contributors,
        params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/moderators',
            as: :moderators,
        params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/muted',
            as: :muted,
        params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/wikibanned',
            as: :wikibanned,
        params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
    consume '/r/:subreddit/about/wikicontributors',
            as: :wikicontributors,
        params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
    consume '/r/:subreddit/api/delete_sr_banner',
            as: :delete_banner,
         using: :post
    consume '/r/:subreddit/api/delete_sr_header',
            as: :delete_header,
         using: :post
    alias delete_logo delete_header
    consume '/r/:subreddit/api/delete_sr_icon',
            as: :delete_icon,
         using: :post
    consume '/r/:subreddit/api/delete_sr_img',
            as: :delete_image,
         using: :post
    consume '/api/recommend/sr/:srnames',
            as: :recommended_reddits,
        params: { optional: :omit }
    consume '/api/search_reddit_names',
            as: :search_reddit_names,
         using: :post
    consume '/api/site_admin',
            as: :new_subreddit,
         using: :post
    consume '/r/:subreddit/api/submit_text',
            as: :submission_text
    consume '/r/:subreddit/api/subreddit_stylesheet',
            as: :update_stylesheet,
         using: :post
    consume '/api/subreddits_by_topic',
            as: :subreddits_by_topic,
        params: { required: :query }
    consume '/api/subscribe',
            as: :subscribe,
         using: :post
    consume '/r/:subreddit/api/upload_sr_img',
            as: :new_image,
         using: :post
    consume '/r/:subreddit/about',
            as: :subreddit_info
    consume '/r/:subreddit/about/edit',
            as: :subreddit_settings
    consume '/r/:subreddit/rules',
            as: :subreddit_rules
    consume '/r/:subreddit/sidebar',
            as: :subreddit_sidebar
    consume '/r/:subreddit/sticky',
            as: :subreddit_sticky
    consume '/subreddits/mine/subscriber',
            as: :my_subscribed,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/mine/contributor',
            as: :my_approved,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/mine/moderator',
            as: :my_moderated,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/search',
            as: :subreddit_search,
        params: { required: :q, optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/default',
            as: :default_subreddits,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/gold',
            as: :gold_subreddits,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/new',
            as: :new_subreddits,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    consume '/subreddits/popular',
            as: :popular_subreddits,
        params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
    # users
    consume '/api/setpermissions',
            as: :update_permissions,
         using: :post
    consume '/api/username_available',
            as: :username_available?
    consume '/api/v1/me/friends/:username',
            as: :friend_info
    consume '/api/v1/me/friends/:username',
            as: :friend,
         using: :put
    alias update_friend friend
    consume '/api/v1/me/friends/:username',
            as: :delete_friend,
         using: :delete
    consume '/api/v1/user/:username/trophies',
            as: :trophies
    consume '/user/:username/about',
            as: :about_user
    consume '/user/:username/overview',
            as: :user,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/comments',
            as: :user_comments,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/gilded',
            as: :user_guilded,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/hidden',
            as: :user_hidden,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/saved',
            as: :user_saved,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/submitted',
            as: :user_submitted,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/upvoted',
            as: :user_upvoted,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    consume '/user/:username/downvoted',
            as: :user_downvoted,
        params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
    # wiki
    consume '/r/:subreddit/api/wiki/alloweditor/add',
            as: :add_wiki_editor_to_page,
         using: :post
    consume '/r/:subreddit/api/wiki/alloweditor/del',
            as: :remove_wiki_editor_from_page,
         using: :post
    consume '/r/:subreddit/api/wiki/edit',
            as: :edit_wiki_page,
         using: :post
    consume '/r/:subreddit/api/wiki/hide',
            as: :hide_wiki_page,
         using: :post
    consume '/r/:subreddit/api/wiki/revert',
            as: :revert_wiki_page,
         using: :post
    consume '/r/:subreddit/wiki/discussions/:page',
            as: :wiki_page_discussions,
        params: { optional: %i(after before count limit page show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/wiki/pages',
            as: :wiki_pages
    consume '/r/:subreddit/wiki/revisions',
            as: :recent_wiki_revisions,
        params: { optional: %i(after before count limit page show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/wiki/revisions/:page',
            as: :recent_wiki_page_revisions,
        params: { optional: %i(after before count limit page show sr_detail) } # TODO: Genericize into listing type
    consume '/r/:subreddit/wiki/settings/:page',
            as: :wiki_page_settings
    consume '/r/:subreddit/wiki/settings/:page',
            as: :update_wiki_page_settings,
         using: :post
    consume '/r/:subreddit/wiki/:page',
            as: :wiki_page,
        params: { optional: %i(v v2) }
  end
end
