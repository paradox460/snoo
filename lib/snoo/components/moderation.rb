module Snoo
  module Components
    # Moderation consumer methods
    module Moderation
      def self.included(base)
        base.class_eval do
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
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/approve',
                  as: :approve,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/distinguish',
                  as: :distinguish,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/ignore_reports',
                  as: :ignore_reports,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/leavecontributor',
                  as: :leave_contributor,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/leavemoderator',
                  as: :leave_moderator,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/mute_message_author',
                  as: :mute_message_author,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/remove',
                  as: :remove,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/unignore_reports',
                  as: :unignore_reports,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/unmute_message_author',
                  as: :unmute_message_author,
               using: :post # TODO: Implement post body params
        end
      end
    end
  end
end
