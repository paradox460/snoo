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
    consume '/api/v1/me/trophies', as: :trophies

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
    # TODO: all below
    # listings
    #       + /by_id/names
    #       + /comments/article
    #       + /controversial
    #       + /duplicates/article
    #       + /hot
    #       + /new
    #       + /random
    #       + /related/article
    #       + /top
    #       + /sort
    # live threads
    #       + /api/live/create
    #       + /api/live/thread/accept_contributor_invite
    #       + /api/live/thread/close_thread
    #       + /api/live/thread/delete_update
    #       + /api/live/thread/edit
    #       + /api/live/thread/invite_contributor
    #       + /api/live/thread/leave_contributor
    #       + /api/live/thread/report
    #       + /api/live/thread/rm_contributor
    #       + /api/live/thread/rm_contributor_invite
    #       + /api/live/thread/set_contributor_permissions
    #       + /api/live/thread/strike_update
    #       + /api/live/thread/update
    #       + /live/thread
    #       + /live/thread/about
    #       + /live/thread/contributors
    #       + /live/thread/discussions
    # private messages
    #       + /api/block
    #       + /api/collapse_message
    #       + /api/compose
    #       + /api/read_all_messages
    #       + /api/read_message
    #       + /api/unblock_subreddit
    #       + /api/uncollapse_message
    #       + /api/unread_message
    #       + /message/inbox
    #       + /message/sent
    #       + /message/unread
    #       + /message/where
    # misc
    #       + /api/v1/scopes
    # moderation
    #       + /about/edited
    #       + /about/log
    #       + /about/modqueue
    #       + /about/reports
    #       + /about/spam
    #       + /about/unmoderated
    #       + /about/location
    #       + /api/accept_moderator_invite
    #       + /api/approve
    #       + /api/distinguish
    #       + /api/ignore_reports
    #       + /api/leavecontributor
    #       + /api/leavemoderator
    #       + /api/mute_message_author
    #       + /api/remove
    #       + /api/unignore_reports
    #       + /api/unmute_message_author
    #       + /stylesheet
    # multis
    #       + /api/filter/filterpath
    #       + /api/filter/filterpath/r/srname
    #       + /api/multi/copy
    #       + /api/multi/mine
    #       + /api/multi/rename
    #       + /api/multi/user/username
    #       + /api/multi/multipath
    #       + /api/multi/multipath/description
    #       + /api/multi/multipath/r/srname
    # search
    #       + /search
    # subreddits
    #       + /about/banned
    #       + /about/contributors
    #       + /about/moderators
    #       + /about/muted
    #       + /about/wikibanned
    #       + /about/wikicontributors
    #       + /about/where
    #       + /api/delete_sr_banner
    #       + /api/delete_sr_header
    #       + /api/delete_sr_icon
    #       + /api/delete_sr_img
    #       + /api/recommend/sr/srnames
    #       + /api/search_reddit_names
    #       + /api/site_admin
    #       + /api/submit_text
    #       + /api/subreddit_stylesheet
    #       + /api/subreddits_by_topic
    #       + /api/subscribe
    #       + /api/upload_sr_img
    #       + /r/subreddit/about
    #       + /r/subreddit/about/edit
    #       + /rules
    #       + /sidebar
    #       + /sticky
    #       + /subreddits/default
    #       + /subreddits/gold
    #       + /subreddits/mine/contributor
    #       + /subreddits/mine/moderator
    #       + /subreddits/mine/subscriber
    #       + /subreddits/mine/where
    #       + /subreddits/new
    #       + /subreddits/popular
    #       + /subreddits/search
    #       + /subreddits/where
    # users
    #       + /api/friend
    #       + /api/setpermissions
    #       + /api/unfriend
    #       + /api/username_available
    #       + /api/v1/me/friends/username
    #       + /api/v1/user/username/trophies
    #       + /user/username/about
    #       + /user/username/comments
    #       + /user/username/downvoted
    #       + /user/username/gilded
    #       + /user/username/hidden
    #       + /user/username/overview
    #       + /user/username/saved
    #       + /user/username/submitted
    #       + /user/username/upvoted
    #       + /user/username/where
    # wiki
    #       + /api/wiki/alloweditor/add
    #       + /api/wiki/alloweditor/del
    #       + /api/wiki/alloweditor/act
    #       + /api/wiki/edit
    #       + /api/wiki/hide
    #       + /api/wiki/revert
    #       + /wiki/discussions/page
    #       + /wiki/pages
    #       + /wiki/revisions
    #       + /wiki/revisions/page
    #       + /wiki/settings/page
    #       + /wiki/page
  end
end
