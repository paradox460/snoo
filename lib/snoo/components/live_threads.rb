module Snoo
  module Components
    # Live Threads consumer methods
    module LiveThreads
      def self.included(base)
        base.class_eval do
          consume '/api/live/create',
                  as: :new_live_thread,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/accept_contributor_invite',
                  as: :accept_live_thread_invite,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/close_thread',
                  as: :close_live_thread,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/delete_update',
                  as: :delete_live_thread_update,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/edit',
                  as: :edit_live_thread,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/invite_contributor',
                  as: :live_thread_invite,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/leave_contributor',
                  as: :live_thread_leave,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/report',
                  as: :live_thread_report,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/rm_contributor',
                  as: :live_thread_remove_contributor,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/rm_contributor_invite',
                  as: :live_thread_remove_contributor_invite,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/set_contributor_permissions',
                  as: :live_thread_contributor_permissions,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/strike_update',
                  as: :live_thread_strike_update,
               using: :post # TODO: Implement post body params
          consume '/api/live/:thread/update',
                  as: :live_thread_update,
               using: :post # TODO: Implement post body params
          consume '/live/:thread',
                  as: :live_thread
          consume '/live/:thread/about',
                  as: :live_thread_about
          consume '/live/:thread/contributors',
                  as: :live_thread_contributors
          consume '/live/:thread/discussions',
                  as: :live_thread_discussions
        end
      end
    end
  end
end
